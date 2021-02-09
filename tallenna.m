function tallenna(tallenne,lista,korvaus)
  tied = fopen(tallenne,korvaus);
  b=fileread(tallenne);
  if regexp(b,'\n$','end') || length(b)==0
  else
    fprintf(tied,'\n');
  endif
  for i=1:rows(lista)
     fprintf(tied, '%s\n',lista{i});
     fprintf(tied, '%s\n',lista{i,2});
  endfor
  fclose(tied);
end
