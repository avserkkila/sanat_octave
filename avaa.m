function lista=avaa(sanasto,lista)
  if !exist('lista','var') || isempty(lista) || !iscell(lista)
    lista = {};
    tiedostonro = 0;
  else
    tiedostonro = max([lista{:,4}]);
  end

  if iscell(sanasto)
    lista=avaa(sanasto{1},lista);
    sanasto(1)=[];
    if ~isempty(sanasto)
      lista=avaa(sanasto,lista);
    end
    return;
  end

  a = fopen(sanasto);
  i=rows(lista);
  j = 1;
  tiedostonro++;
  while ~feof(a)
    sana = {fgetl(a)};
    lista(++i,:) = [sana {fgetl(a)} {j++} {tiedostonro}];
  endwhile
  fclose(a);
end
