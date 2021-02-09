function [lista,osatut] = kierrokselleKomento(lista, osatut, args);
  global aukiOleva;
  global aukiOlevaRegExp; #aukiOleva, josta aktiivisen luvun paikka on merkittyt
  global aukiOlevaRegExpYrite;
  global kokoPituus;
  global liitto;
  global naytaPituus;
  switch args{1}
    case 'JÄTÄ'
      if (( n = str2num(args{2}) ))
        try osatut(randperm(length(osatut),n)) = [];
          lista(osatut,:) = '';
        catch printf('EI POISTETTAVAA\n') end;
      endif
      args(1) = [];
    case '0'
      lista(:,[1 2]) = lista(:,[2 1]);
    case '2'
    case '1'
      lista=avaa(aukiOleva);
    case {'' 'poista'}
      try lista(osatut,:) = ''; end
    case '-a'
      liitto = lista;
    case '#'
      lukema = str2num(args{2});
      try lista(randperm(rows(lista),rows(lista)-lukema),:) = [];
      catch printf('EI POISTETTAVAA\n'); end;
      args(1) = '';
    case {'<<' '>>'}
      if strcmp(args{1},'<<') suunta = 'ascend';
      else suunta = 'descend'; end;
      if iscell(aukiOlevaRegExp)
        yrite = listaaTiedostot(aukiOlevaRegExp{end},suunta);
      else
        yrite = listaaTiedostot(aukiOlevaRegExp,suunta);
      end
      if iscell(aukiOleva)
        i=find(strcmp(yrite,aukiOleva{end}));
      else
        i=find(strcmp(yrite,aukiOleva));
      end
      if i == 1
        disp('Ei ole seuraavaa tuossa suunnassa');
        kysyKomento(lista,osatut);
        return;
      end
      if isempty(i) i = 2; end # jos ei löydy auki olevan indeksiä, olkoon --i = 1
      if length(args) == 1
        args{2} = ['\' yrite{--i}]; #'
      else
        args = [args(1) {['\' yrite{--i}]} args(2:end)]; #'
      end
      printf('Avataan tiedosto %s\n' ,args{2}(2:end));
    case {'<' '>'}
      if length(args) == 1
        args{1} = repmat(args{1},[1 2]);
        kysyKomento(lista, osatut, args);
        return;
      end
      if strcmp(args{1},'<') suunta = 'ascend';
      else suunta = 'descend'; end;
      yrite = listaaTiedostot(args{2},suunta);
      aukiOlevaRegExpYrite = args{2};
      if isempty(yrite)
        disp('Ei ole numeroitua sanastoa tuolla nimellä');
        kysyKomento(lista, osatut);
        return;
      end
      args{2} = ['\' yrite{1}]; #'
      printf('Avataan tiedosto %s\n', args{2}(2:end));
    case {'.<' '.>'}
      if strcmp(args{1},'.<')
        suunta = 'ascend';
      else
        suunta = 'descend';
      end
      [a,b] = regexp(aukiOleva,'.*\D(?=\d+)','match','split');
      try a=a{1}; catch a=''; end
      try b=b{2}; catch b=''; end
      b=regexprep(b,'\d+','()'); # luku korvataan suluilla
      yrite=listaaTiedostot([a b], suunta);
      i = find(strcmp(yrite,aukiOleva));
      if i==1
        disp('Ei ole seuraavaa tuossa suunnassa');
        kysyKomento(lista,osatut);
      end
      if length(args) == 1
        args = {'ohi' '.' ['\' yrite{--i}]}; #'
      else
        args = {'ohi' '.' ['\' yrite{--i}] args{2:end}}; #'
      end
    case 'AVAA_KAIKKI'
      try nimet = listaaTiedostot(args{2});
      catch nimet = listaaTiedostot(); end
      args{2} = 'mene_otherwiseen'; # nimet on cell eikä toimi switchissä
      args{3} = nimet'; #'
    otherwise
      if strcmp(args{1},'mene_otherwiseen')
        args(1) = '';
      end
      yrite=regexprep(args{1},'^\\','');
      try
        lista=avaa(yrite,liitto);
        onnistui = 1;
      catch
        onnistui = 0;
      end
      if onnistui #tiedoston lukeminen onnistui
      #näitä ei sijoiteta try:n sisälle, koska virheistä ei saataisi silloin ilmoituksia
        if !isempty(liitto)
          if ischar(aukiOleva)
            aukiOleva = {aukiOleva};
          end
          aukiOleva = [aukiOleva; yrite];
        else
          aukiOleva = yrite;
          aukiOlevaRegExp = aukiOlevaRegExpYrite;
        end
        kokoPituus = rows(lista);
        naytaPituus = 1;
      else
        if iscell(yrite)
          str = 'yrite{:}';
        else
          str = 'yrite';
        end
        form = repmat(' %s',[1 rows(yrite)]);
        printf(['Ei voi avata tiedostoa ' form(2:end) '\n'], eval(str));
        kysyKomento(lista, osatut);
        return;
      end
      liitto = {};
  end
  args(1) = [];
  if isempty(args)
    if naytaPituus
      printf('Sanoja %d\n', kokoPituus)
      naytaPituus = 0;
    end
    kierros(lista);
  else
    kysyKomento(lista, osatut, args);
  end
end
