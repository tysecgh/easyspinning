_margin_ = 1;
_inflate_ = 3;

$holeflg = true;
$chamfflg = true;




module board(p, h){
	linear_extrude(h) square(p);
}

module chamf(chmfw,h){
	if( chmfw> 0){
		if( $chamfflg ){
			csize = min(5,chmfw/3);
			csp = min(csize*2.7,chmfw-1);
			translate([0,0,-_margin_])
			linear_extrude(h+_margin_*2){
				text(str(chmfw),size = csize,font = "Noto Sans JP");
				polygon([
					[csp,-_margin_],
					[chmfw,0],
					[0,chmfw],
					[-_margin_,csp]
				]);
			}
		}else{
			translate([0,0,-_margin_])
			linear_extrude(h+_margin_*2)
			polygon([
				[-_margin_,-_margin_],
				[chmfw,0],
				[0,chmfw]
			]);
		}
	}
}


module cMarker(r,h){
	translate([0,0,0-_margin_])
	difference(){
		cylinder(h=h+_margin_*2,r=r*0.9,$fn=24);
		translate([0,0,0-_margin_]) cube( [r,r,h+_margin_*4] );
	}
}



module hole(r,h){
	translate([0,0,0-_margin_])
	difference(){
		cylinder(h=h+_margin_*2,r=r,$fn=24);


		if( $holeflg ){
			if( r > 10 ){
				translate([1,1,0-_margin_])
				linear_extrude(height=h+_margin_*4){
					text( str("r",r), size=3);
				}
				cMarker(9,h+_margin_*2);

			}
			else{
				cMarker(r*0.9,h+_margin_*2);
			}
		}
	}

}

module cutSq(p, h){
	translate([0,0,0-_margin_])
	board(p, h=h+_margin_*2);
}


/////////////////////////////////
//// 汎用部品
/////////////////////////////////
pin_rad = 1.5;

module pin(h){
	cylinder(h=h,r=pin_rad,$fn=24);
}

module crown_pins(pr,pnum,ph){
	for( i=[0:pnum-1]){
		rotate([0,0,i*360/pnum])
		translate([pr,0,0])
		pin( ph );
	}
}

module crown_holes(pr,pnum,h){
	for( i=[0:pnum-1]){
		rotate([0,0,i*360/pnum])
		translate([pr,0,0])
		hole( pin_rad,h );
	}
}

module pin_disc_crown_disc(r,h,pr,pnum){
	difference(){
		cylinder(h=h,r=r,$fn=96);
		crown_holes(pr,pnum,h);
	}
}

module pin_disc_crown(r,h,pr,ph,pnum){
	cylinder(h=h,r=r,$fn=96);
	for( i=[0:pnum-1]){
		rotate([0,0,i*360/pnum])
		translate([pr,0,0])
		pin( h+ph );
	}
}

module pin_disc(r,h,ph,pnum){
	cylinder(h=h,r=r,$fn=96);
	for( i=[0:pnum-1]){
		rotate([0,0,i*360/pnum])
		translate([r,0,h/2])
		rotate([0,90,0])
		pin( ph );
	}
}
