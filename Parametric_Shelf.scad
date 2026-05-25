Inner_height = 10;
Inner_width = 20;
Inner_depth = 5;
Thickness = 1.5;
No_Boxes_high = 2;
No_Boxes_wide = 3;
Back = true;
Rounded_Corners = true;
Corner_Radius = 3;

box_red = 100/255;
box_green = 50/255;
box_blue = 0/255;
c_color = 180/255;
cut_color = [c_color,c_color,c_color];
MainBox_Color = [box_red,box_green,box_blue];
Outer_height = Inner_height*No_Boxes_high+Thickness*(No_Boxes_high+1);
Outer_width = Inner_width*No_Boxes_wide+Thickness*(No_Boxes_wide+1);
Outer_depth = (Back) ? Inner_depth+Thickness:Inner_depth;
True_height = (Rounded_Corners) ? Outer_height-Corner_Radius:Outer_height;
True_width = (Rounded_Corners) ? Outer_width-Corner_Radius:Outer_width;
extra = 0+0.02;
cut_offset = (Rounded_Corners) ? [Corner_Radius/2,0,Corner_Radius/2]:[0,0,0];
module Main_Box() {
     color(c = MainBox_Color)
     cube([
     True_width,
     Outer_depth,
     True_height]);
};
module Cut_outs() {
    translate(cut_offset)
        for (i=[0:No_Boxes_high-1]){
            translate([0,0,i*(Inner_height+Thickness+extra)])    
                translate([Thickness,-extra,Thickness])
                    color(c = cut_color)
                    cube([
                    Inner_width,
                    Inner_depth+extra*2,
                    Inner_height]);
            for (j=[0:No_Boxes_wide-1]){
                translate([j*(Inner_width+Thickness+extra),0,i*(Inner_height+Thickness+extra)])    
                    translate([Thickness,-extra,Thickness])
                        color(c = cut_color)
                        cube([
                        Inner_width,
                        Inner_depth+extra*2,
                        Inner_height]);
        };
    };
};
module Fillet(){
    color(c = MainBox_Color)
    minkowski(){
    translate([Corner_Radius,0,Corner_Radius])
        Main_Box();
        rotate([90,0,0])
           cylinder(r=Corner_Radius,h=0.001); 
    };
};

module Full_Box() {
    difference(){
        if (Rounded_Corners) Fillet();
        if (!Rounded_Corners) Main_Box();
        Cut_outs();
    };
};

Full_Box();
