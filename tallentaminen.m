function ret = tallentaminen(args, lista, osatut)
  global aukiOleva;
  if ~strcmp(lower(args{1}),'tallenna')
    printf("Tallentamisfunktio kutsuttiin väärin komennoin\n")
    ret = '';
    return
  endif
  lista(osatut,:) = '';
  switch length(args)
   case 1
      tallenna(aukiOleva, lista,'w');
      ret = aukiOleva;
      return
   case 2
      if strfind(args{2}, '\d')
        paiva = datestr(now,'yymmdd');
        args{2} = strrep(args{2}, '\d', paiva);
      end
      tallenna(args{2}, lista, 'a');
   otherwise
      if exist(args{3},'file')
        if ~input(['Korvataanko tiedosto "' args{3} '"? (0/1) ']);
          ret = '';
          return;
        endif
      endif
      tallenna(args{2}, lista, 'a');
      system(['mv ' args{2} ' ' args{3}]);
      if strcmp(aukiOleva, args{2})
        aukiOleva = args{3};
      endif
  end
  ret = args{end};
end
