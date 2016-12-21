
   // preload images for menu rollovers

   if (document.images) 
   {
      // main menu

      menudir = '/clients/byerschool/images/';

      toolbarHome1 = new Image(43,23);
      toolbarHome1.src = menudir + 'home1.gif';
      toolbarHome2 = new Image(43,23);
      toolbarHome2.src = menudir + 'home2.gif';

      toolbarAbout1 = new Image(74,23);
      toolbarAbout1.src = menudir + 'about1.gif';
      toolbarAbout2 = new Image(74,23);
      toolbarAbout2.src = menudir + 'about2.gif';

      toolbarCurriculum1 = new Image(87,23);
      toolbarCurriculum1.src = menudir + 'curriculum1.gif';
      toolbarCurriculum2 = new Image(87,23);
      toolbarCurriculum2.src = menudir + 'curriculum2.gif';

      toolbarExpeditionary1 = new Image(162,23);
      toolbarExpeditionary1.src = menudir + 'expeditionary1.gif';
      toolbarExpeditionary2 = new Image(162,23);
      toolbarExpeditionary2.src = menudir + 'expeditionary2.gif';

      toolbarEnrollment1 = new Image(85,23);
      toolbarEnrollment1.src = menudir + 'enrollment1.gif';
      toolbarEnrollment2 = new Image(85,23);
      toolbarEnrollment2.src = menudir + 'enrollment2.gif';

      toolbarAlumni1 = new Image(60,23);
      toolbarAlumni1.src = menudir + 'alumni1.gif';
      toolbarAlumni2 = new Image(60,23);
      toolbarAlumni2.src = menudir + 'alumni2.gif';

      toolbarInvest1 = new Image(152,23);
      toolbarInvest1.src = menudir + 'invest1.gif';
      toolbarInvest2 = new Image(152,23);
      toolbarInvest2.src = menudir + 'invest2.gif';
   }

   // simple image replacements

   function rollOn(imgID)
   {
      if (document.images) document.images[imgID].src = eval(imgID + '2.src'); 
   }

   function rollOff(imgID)
   {
      if (document.images) document.images[imgID].src = eval(imgID + '1.src'); 
   }

