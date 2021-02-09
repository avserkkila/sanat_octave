#Palautetaan character-stringin pituus
#Length-funktio palauttaisi pituuden tavuina, mikä ei ole erikoismerkkien tapauksessa sama kuin merkkien määrä.
#UTF-8:ssa yksitavuisten merkkien ensimmäinen bitti on nolla.
#Useampitavuiset alkavat niin monella ykkösellä kuin merkissä on tavuja.

function len = strlen(a)
  if length(a) == 0
    len = 0;
    return;
  end
  if iscell(a)
    len = [];
    while !isempty(a)
      len = [len strlen(a{1})];
      a(1) = '';
    endwhile
    return;
  endif

#Bittimuodossa jokainen yksittäinen tavu on aluksi oikealta vasemmalle.
#Käännetään tavut luettavaksi vasemmalta oikealle
  b1=bitunpack(a);
  b=[];
  alku = 1;
  loppu = 8;
  while loppu <= length(b1)
    tavu = b1(alku:loppu);
    b=[b fliplr(tavu)];
    alku += 8;
    loppu += 8;
  end

  len=0;
  while !isempty(b)
    ind=find(!b); #Nollien sijainnit
    nolla=ind(1);
    if nolla==1
      b(1:8)='';
    else
      hyppy = nolla - 1; #Tavujen määrä kyseisessä merkissä
      b(1:hyppy*8)='';
    end
    len++;
  end
end
