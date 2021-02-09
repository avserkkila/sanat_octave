function lista = listaaTiedostot(nimi,suunta)
  yrite = ls;
  yrite(:,length(yrite)+1) = ' ';
  yrite = (reshape(yrite',[],1))'; # lista yhteen riviin
  yrite = regexp(yrite,'\S+','match'); # nimet listalta soluihin
  yrite(find(strcmp(yrite,'')))=''; # tyhjät pois
  if !exist('nimi','var') || isempty(nimi)
    nimi = ')('; # tämä merkitsee nyt tyhjää
  end
  if !exist('suunta','var') suunta='ascend'; end
		   
### luvun paikka merkitään sulkeilla, tässä on luvun vaihto sulkeiksi
### jos niitä ei jo ole eikä nimi ole komento: )( tai eriNimet
  if isempty(strfind(nimi,'()')) && !any(strcmp(nimi,{')(' 'eriNimet'}))
    [a,b] = regexp(nimi,'.*\D(?=\d+)','match','split');
    try a=a{1}; catch a=''; end
    try b=b{2};
    catch try b=b{1}; catch b=''; end
    end
    b=regexprep(b,'\d+','()'); # korvataan luku sulkeilla
    if isempty(strfind(b,'()')) # lukua ei ollut --> sulkeet loppuun
      b=[b '()'];
    end
    nimi = [a b];
  end

#-- haetaan kaikista nimistä ne, jotka vastaavat hakuehtoa
  if !any(strcmp(nimi, {')(' 'eriNimet'}))
    ehto = strrep(nimi,'()','\d+');
    ehto = strrep(ehto, '.', '\.');   # paetaan piste eli '.' -> '\.'
    ehto = ['^' ehto '$'];            # oikean nimen muokoinen regex
    ind_oikeat = [];                  # haluttujen nimien indeksit;
    for i = 1:length(yrite)
      if regexp(yrite{i},ehto)
	ind_oikeat = [ind_oikeat i];
      end
    end
    yrite = yrite(ind_oikeat);
  end

#-- muodostetaan regexp:n hakuehto oikean luvun löytämiseksi
#-- näillä saadaan osuma osiosta ennen lukua
  if !any(strcmp( nimi, {')(' 'eriNimet'} ) )
    ehto = [strrep(ehto, '\d+', '(?=\d+') ')']; # esim A\d+_0 -> A(?=\d+_0)
    #loppu pitää poistaa erikseen
  else
    ehto = '.*\D(?=\d+)'; # mitä tahansa ja lopussa luku
  end

#-- nimistä käytettävät luvut eri listaan 'luvut'
  luvut={};
  for i=1:length(yrite)
    b = regexp(yrite{i}, ehto, 'split');
    b = b{end};
    loppu_ind = regexp(b,'^\d+','end');
    luvut(i) = {str2num(b(1:loppu_ind))}; # cell koska voi tulla tyhjiäkin
  end

#-- nyt nimistä oikeat luvut sulkeiksi
  for i=1:length(yrite)
    [a,b]=regexp(yrite{i},ehto,'match','split');
    try a=a{1}; catch a=''; end
    try b=b{2};
    catch try b=b{1}; catch b=''; end
    end
    b=regexprep(b,'^\d+','()');
    yrite{i} = [a b];
  end

### haetaan kaikki eri nimet eli ilman numeroita erilaiset (turhaa jos oli joku hakuehto)
  eriNimet={};
  for i=1:length(yrite)
    if !any(strcmp(eriNimet,yrite{i}))
      eriNimet=[eriNimet yrite(i)];
    end
  end

### jos halutaan palauttaa eri nimet, tehdään niistä tuloste ja poistutaan
  if strcmp(nimi,'eriNimet')
    lista = eriNimet;
    for i=1:length(lista)
      lista{i} = [lista{i} "\t(" num2str(length(find(strcmp(yrite,lista{i})))) ' kpl)'];
    end
    return
  end

### järjestetään eri nimien mukaan ja numeroidaan
  lista = {};
  for i=1:length(eriNimet)
    j=find(strcmp(yrite,eriNimet{i}));
    tmpLuvut = sort([luvut{j}]);
    if isempty(tmpLuvut)
      tmpLuvut = -1;
    end
    tmpLista = yrite(j);
    for k=1:length(j)
      if tmpLuvut < 0 break; end
      tmpLista{k} = strrep(tmpLista{k},'()',num2str(tmpLuvut(k)));
    end
    lista = [lista tmpLista];
  end

if strcmp(suunta,'descend')
  lista = fliplr(lista);
end
