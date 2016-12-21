
   // set up map

   function mapInit()
   {
      x = 276; y = 330;
      map0 = new Image(x,y);  map0.src = '/images/rcodemap/0.gif';
      map0r = new Image(x,y); map0r.src = '/images/rcodemap/0r.gif';
      map1 = new Image(x,y);  map1.src = '/images/rcodemap/1.gif';
      map1r = new Image(x,y); map1r.src = '/images/rcodemap/1r.gif';
      map2 = new Image(x,y);  map2.src = '/images/rcodemap/2.gif';
      map2r = new Image(x,y); map2r.src = '/images/rcodemap/2r.gif';
      map3 = new Image(x,y);  map3.src = '/images/rcodemap/3.gif';
      map3r = new Image(x,y); map3r.src = '/images/rcodemap/3r.gif';
      map4 = new Image(x,y);  map4.src = '/images/rcodemap/4.gif';
      map4r = new Image(x,y); map4r.src = '/images/rcodemap/4r.gif';
      map5 = new Image(x,y);  map5.src = '/images/rcodemap/5.gif';
      map5r = new Image(x,y); map5r.src = '/images/rcodemap/5r.gif';
      map6 = new Image(x,y);  map6.src = '/images/rcodemap/6.gif';
      map6r = new Image(x,y); map6r.src = '/images/rcodemap/6r.gif';
   }

   // select a map region

   function mapSelect(r)
   {
      document.images['rcodemap'].src = eval('map' + r + '.src');
      document.getElementById('rcode').value = r;
   }

   // mouse over a map region

   function mapOn(r)
   {
      document.images['rcodemap'].src = eval('map' + r + 'r.src');
   }

   // mouse out of a map region

   function mapOff()
   {
      document.images['rcodemap'].src = eval('map' + document.getElementById('rcode').value + '.src'); 
   }


