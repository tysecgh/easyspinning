include <./lib/mylib.scad>
$holeflg = false;

module PART_A1(){
    difference(){
        linear_extrude(6)
        polygon([
            [-20,9],[-9,20],[9,20],[20,9],
            [20,-9],[9,-20],[-9,-20],[-20,-9],
            [-23,-9],[-23,0],[-29,0],[-29,-9],
            [-34,-9],[-34,9]
        ]);

        hole(3,6);
        crown_holes(17,6,6);
    }
}


module PART_A2(){
    difference(){
        cylinder(r=20,h=6,$fn=64);

        hole(3,6);
        crown_holes(17,6,6);
    }
}

module PART_A3(){
    difference(){
        linear_extrude(6)
        polygon([
            [-9,0],[-9,5],[0,5],[0,11],
            [-9,11],[-9,sp_width+23],[9,sp_width+23],
            [9,sp_width+12],
            [0,sp_width+12],[0,sp_width+11],[9,sp_width+11],[9,0]
        ]);

        translate([0,sp_width+15,0])
        hole(3,6);
    }
}
module ASSY_A(){
    translate([0,0,24]){
        translate([-23,0,-5])
        rotate([90,0,-90])
        PART_A3();

        PART_A1();
    }
    PART_A2();
    crown_pins(17,6,30);
}

sp_width = 12;

module ASSY_AX(){
    translate([-23,0,-5])
    rotate([90,0,-90])
    PART_A3();

    PART_A1();
}

module PART_B1(){
    difference(){
        cylinder(r=40,h=6,$fn=64);

        hole(3,6);
        crown_holes(37,12,6);
    }
}

module ASSY_B(){
    PART_B1();
    crown_pins(37,12,15);


    translate([0,0,-3])cylinder(r=3,h=48,$fn=32);

    translate([0,0,36])
        linear_extrude(6)
        polygon([
            [-6,-6],[-6,6],[6,6],[6,-6]
        ]);
    rotate([0,0,15]) translate([30,0,-30]) 
    cylinder(r=3,h=30,$fn=32);
}



module PART_C1(){
    difference(){
        linear_extrude(6)
        polygon([
            [-18,-20],[-18,20],[2,20],[2,60],
            [22,60],[22,-20]
        ]);
        hole(3,6);
    }
}

module PART_C2(){
    difference(){
        linear_extrude(6)
        polygon([
            [-18,-20],[-18,20],[2,20],[2,60],
            [22,60],[22,1],[7,1],[7,-5],[22,-5],[22,-20]
        ]);
        hole(3,6);
    }
}

module PART_C3(){
    difference(){
        linear_extrude(6)
        polygon([
            [-18,-20],[-18,20],[2,20],[2,60],
            [22,60],[22,-20]
        ]);
        hole(3,6);
    }
}

module PART_C4(){
    difference(){
        linear_extrude(6)
        polygon([
            [-18,-20],[-18,20],[22,20],[22,-20]
        ]);
        hole(3,6);
    }
}

module PART_C5(){
    difference(){
        linear_extrude(6)
        polygon([
            [-18,-20],[-18,20],[22,20],[22,-20]
        ]);
        hole(3,6);
    }
}


module ASSY_C(){
    translate([0,0,+15]) PART_C5();
    translate([0,0,+9]) PART_C4();
    translate([0,0,+3]) PART_C3();
    translate([0,0,-3]) PART_C2();
    translate([0,0,-9]) PART_C1();
}







module PART_D1(){
    difference(){
        cylinder(r=20,h=6,$fn=64);

        hole(3,6);
    }
}

module PART_D2(){
    difference(){
        cylinder(r=15,h=sp_width+1,$fn=64);

        hole(3,sp_width+1);
    }
}

module PART_D3(){
    difference(){
        cylinder(r=20,h=6,$fn=64);

        hole(3,6);
    }
}

module ASSY_D(){
    translate([0,0,sp_width+1+6]) PART_D1();
    translate([0,0,6]) PART_D2();
    PART_D3();
    
    translate([0,0,-45])
    cylinder(r=3,h=63,$fn=32);
}

module ASSY_DX(){
    translate([0,0,sp_width+1+6]) PART_D1();
    translate([0,0,6]) PART_D2();
    PART_D3();
}


////////////////////


module VIEWX_C(){
    rotate([90,0,0]) ASSY_C();
}
module VIEWX_B(theta=0){
    translate([0,-27,0]) rotate([-90,0,0]) 
        rotate([0,0,theta])ASSY_B();
}
module VIEWX_D(){
    translate([52,0,-2])rotate([0,90,0])ASSY_D();
}

module VIEWX_A(theta=0){ 
    translate([22,0,-2])rotate([0,90,0])
        rotate([0,0,theta])ASSY_A();
}


module VIEW_SKELETON(t=0){
    VIEWX_A(2*t+33);
    VIEWX_B(t);
}




module beam(p1, p2, w=1) {
    v = p2 - p1;
    L = norm(v); // 2点間の距離
    
    // 水平方向（XY平面）の角度と、垂直方向（Z軸からの傾き）を計算
    xy_dist = norm([v.x,v.y]);
    rot_y = atan2(xy_dist, v.z); 
    rot_z = atan2(v.y, v.x);     

    translate(p1)
    rotate([0, 0, rot_z])
    rotate([0, rot_y, 0])
    // Z軸方向に長さ L の直方体を伸ばす（底面の中央が p1 に一致する）
    translate([-w/2,-w/2,0])cube([w, w, L]);
}



module line(pSq){
    color("red"){
        for( i=[0:1:len(pSq)-2] ){
            beam(pSq[i], pSq[i+1],0.3);
        }        
    }
}

module VIEWX_AX(theta=0){ 
    rotate([0,0,theta])
    ASSY_AX();
}
module VIEWX_DX(theta=0,h=0){
    translate([0,0,6+h]) 
    rotate([0,0,theta])
    ASSY_DX();
}


module VIEW_WITHLINE(t=0){
    VIEWX_AX(t);
    VIEWX_DX(h=6);
    VIEWX_line(t);
}

module VIEW_WITHOC(t=0){
    if( t< 18 ){
        VIEWX_DX(h=6+t*6/18);
    }else if( t<54 ){
        VIEWX_DX(h=12-(t-18)*12/36);
    }else{
        VIEWX_DX(h=0+(t-54)*6/18);
    }
    VIEWX_AX(t*15);
    VIEWX_line(t*15);
}

module VIEW_WITHCO(t=0){
    if( t< 18 ){
        translate([0,0,-(6+t*6/18)]) VIEW_WITHOC(t);
    }else if( t<54 ){
        translate([0,0,-(12-(t-18)*12/36)]) VIEW_WITHOC(t);
    }else{
        translate([0,0,-(0+(t-54)*6/18)]) VIEW_WITHOC(t);
    }
}



module VIEWX_line(theta=0,h=0){
    z = 12+sp_width+h;
    rotate([0,0,theta])
    line([[-9,12,z],[-23,0,z],[-30,0,z],[-30,0,z+10],[-0,0,200]]);
    
    color("red")
    translate([0,0,z-0.3])
    cylinder(r=15.1,h=0.6,$fn=64);
}



module VIEW_WITHLINE2(t=0){
    VIEWX_AX();
    translate([0,0,6]) VIEWX_DX();
    VIEWX_line2(-t);
}

module VIEWX_line2(theta=0){
    translate([52,0,-2])rotate([0,90,0])
    rotate([0,0,theta])
    line([[-9,12,9],[-21,0,12],[-21,-3,19],[-0,0,200]]);
}

//VIEW_WITHLINE();

//VIEW_WITHLINE();

//VIEW_SKELETON();

//    VIEWX_C();
 //   VIEWX_D();