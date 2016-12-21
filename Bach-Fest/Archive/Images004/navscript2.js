        if(document.images) {
                ftover = new Array(2);
                ftout = new Array(2);
                for(var n=1;n<=2;n++) {
                        ftover[n]=new Image(100,20);
                        ftout[n]=new Image(100,20);
                        ftover[n].src="/PrivateLabel/Bach-Fest/Images/roll"+n+"on.gif";
                  	ftout[n].src="/PrivateLabel/Bach-Fest/Images/roll"+n+"off.gif";
                }
        }

        function tabOn(i) {
                if(document.images) document.images["ft"+i].src=ftover[i].src;
        }
        function tabOff(i) {
                if(document.images) document.images["ft"+i].src=ftout[i].src;
        }