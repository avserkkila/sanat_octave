function kysyKomento(lista, osatut, args)
  global aukiOleva;
  global kokoPituus;
  if ~exist('args','var')
    komento = input('Komento: ', 's');
    #hajotetaan sanoihin paitsi jos paettu kenoviivalla
    args = regexp(komento, '(?<!\\)\s', 'split');
    args = strrep(args, '\ ', ' ');
  end
  switch args{1}
     case {'NIMI', 'NYT'}
        disp(aukiOleva);
     case 'E'
        [lista,osatut] = kierros(lista,osatut,'stop');
     case '.'
        if iscell(aukiOleva)
          for i=1:length(aukiOleva)
            system(['mv ' aukiOleva{i} ' ' aukiOleva{i} '. -i']);
          end
	  for i=1:length(aukiOleva)
	    aukiOleva{i} = [aukiOleva{i} '.'];
          end
          printf('Uudet nimet:');
          disp(aukiOleva);
        else
          system(['mv ' aukiOleva ' ' aukiOleva '. -i']);
          aukiOleva = [aukiOleva '.'];
          printf('Uusi nimi: %s\n', aukiOleva);
        end
     case 'OSATUT'
        for i = 1:length(osatut)
	  printf([lista{osatut(i)} ' = ' lista{osatut(i),2} '\n']);
        endfor
     case 'CLEAR'
        system('clear');
     case 'ls'
        if length(args) > 2 && strcmp(args{3},'sl')
          system(['ls ' args{2}]);
          args(1:2) = [];
        else
          ls
        endif
     case 'cd'
        try eval(['cd ' args{2}]);
        catch printf('Ei ole tuota kansiota\n'); end;
        try args(2) = []; end
     case 'SYSTEM'
        system(regexprep(komento,'^SYSTEM ',''));
        args(2:end) = [];
     case 'LISTAA'
        if length(args) == 1
          disp(listaaTiedostot())
        else
          disp(listaaTiedostot(args{2}));
          args(1) = '';
        end
     case {'f' 't' 'exit'}
        return;
     case 'OCTAVE'
        eval(input('>> ', 's'));
     case {'tallenna', 'TALLENNA'}
        if (( nimi = tallentaminen(args, lista, osatut) ))
          kokoPituus = rows(avaa(aukiOleva));
          printf('Tallennettu, pituus %d sanaa\n', rows(avaa(nimi)));
        else
          printf('Ähäkutti, eipäs tallennettukaan\n');
        end
        args(2:end) = [];
     otherwise
        kierrokselleKomento(lista, osatut, args);
        return;
  end
  args(1) = [];
  if isempty(args)
    kysyKomento(lista,osatut);
  else
    kysyKomento(lista,osatut,args);
  end
end
