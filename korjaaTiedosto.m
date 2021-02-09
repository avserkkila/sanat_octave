function korjaaTiedosto(nimi,paikka,kumpi,korjaus)
  if strcmp(kumpi, 'käännös')
    paikka = [paikka 0];
  elseif strcmp(kumpi, 'sana')
    paikka = [paikka 1];
  else
    disp('VIRHE: korjaaTiedosto kutsuttiin määrittelemättä korjataanko "sana" vai "käännös"');
  end
  teksti=fileread(nimi);
  teksti0 = regexp(teksti, char(10), 'split');
  teksti0{paikka(1)*2-paikka(2)} = korjaus;
  teksti1 = '';
  for i = [1:length(teksti0)]
    teksti1 = [teksti1 teksti0{i} char(10)];
  end
  tied=fopen(nimi,'w+');
  try
     fprintf(tied, teksti1(1:end-1));
  catch
     disp('EI VOI TALLENTAA')
     fprintf(tied, teksti);
  end
  fclose(tied);
end
