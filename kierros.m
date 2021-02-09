function [lista,osatut] = kierros(lista,osatut,stop)
  global aukiOleva;
  global kokoPituus;
  if !exist('osatut','var') osatut = [];                             end
  if !exist('stop','var')     stop = 0;                              end
  if !stop                   lista = lista(randperm(rows(lista)),:); end
  if stop i=rows(lista); else i=1; end
  kaanna = 0;
  maks=0;
  suote_on_valmiina = 0;

  for j=1:rows(lista)
    if (( l = strlen(lista{j,1}) )) > maks
      maks = l;
    end
  end
  syotteen_paikka = maks+3;
  user_kaikki     = [];

  while i <= rows(lista)
    valit       = syotteen_paikka - strlen(lista{i});
    if !suote_on_valmiina
      user      = input([lista{i},repmat(' ',[1 valit])],'s');
      user_kaikki = [user_kaikki {user}];
    end
    suote_on_valmiina = 0;

    user_sana_n = regexp(user, '\s*', 'split');
    switch user_sana_n{1}
      case '1'
        if isempty(find(osatut == i-1))
          osatut(length(osatut)+1) = i-1;
        end
        #perään voidaan syöttää käännösyrite
        if length(user) > 1
          suote_on_valmiina = 1;
          user(1:2) = '';
        end
      case '0'
        break;
      case '<'
        i--;
      case '!'
        osatut(find(osatut==i++)) = [];
      case 'LISTA'
        lista
      case 'CLEAR'
        system('clear');
      case 'KÄÄNNÄ'
        kaanna = 1;
      case {'ÄLÄKÄÄNNÄ' '!KÄÄNNÄ'}
        kaanna = 0;
      case '§'
        osatut(length(osatut)+1) = i++;
      case '#'
        printf('%d/%d\n',i,rows(lista));
      case 'OCTAVE'
        eval(user(8:end))
      case 'KORJAA'
	if isempty( maara = str2num(user_sana_n{2}) );
          maara = input('Anna korjattavan sijainti: ');
        end
	parejaTaakse      = floor((maara)/2);
        if rem(maara,2)  #pariton
          kumpi = 'sana';
        else
          kumpi = 'käännös';
        end
	if iscell(aukiOleva)
	  tempNimi   = aukiOleva{lista{i-parejaTaakse, 4}};
	else
	  tempNimi   = aukiOleva;
	end
	tempPaikka   = lista{i-parejaTaakse, 3};
	tempKorjaus  = regexprep(user, '^KORJAA\s+\d*\s*', '');
	korjaaTiedosto(tempNimi, tempPaikka, kumpi, tempKorjaus);
	lista{i-parejaTaakse, 2-rem(maara,2)} = tempKorjaus;
      case 'OLI_OIKEIN'
	if iscell(aukiOleva)
	  tempNimi   = aukiOleva{lista{i-1, 4}};
	else
	  tempNimi   = aukiOleva;
	end
        tempKorjaus  = user_kaikki{end-1};
        korjaaTiedosto(tempNimi, lista{i-1,3}, 'käännös', tempKorjaus);
        lista{i-1, 2} = tempKorjaus;
      otherwise
        user = regexprep(user, '^\\', '');
        if strcmp(user, lista(i,2))
          osatut(length(osatut)+1)=i++;
        else
          printf('%s= %s\n',repmat(' ',[1 strlen(lista{i})+valit-2]),lista{i++,2});
        endif
    endswitch
  endwhile
  if kaanna
    temp = [1:rows(lista)];
    temp(osatut) = [];
    osatut = temp;
  end
  if iscell(aukiOleva)
    str = 'aukiOleva{:}';
  else
    str = 'aukiOleva';
  end
  form = repmat(' %s',[1 rows(aukiOleva)]);
  printf(['Kierrokselta %d/%d. Jäljellä %d/%d (' form(2:end) ')\n'],...
         length(osatut),rows(lista),rows(lista)-length(osatut),kokoPituus,eval(str))
  if stop return; end
  kysyKomento(lista,osatut);
end
