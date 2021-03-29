// TODO:
//   * Move the board and cut-out to the wedge.
//   * Alternately, move the wedge to one side so header fits easier.
//   * Don't extend the case_wire_hole through the outside.
//   * Clean up this code: 
//     - Remove case_offset_z
//     - Build with consistent slope.

wall = 2;
epsilon = 0.1;

case_offset_z = 1;

// Button case dimensions
small_r = 2;
vdist = 12;  // Total height adds 2*small_r
case_y = 60;
case_x = 90;
slope = atan(vdist/case_y);

// Button dimensions
button_xs = [-30, +30];
button_x = 13;
button_y = 15;
button_floor_z = 6;
button_cover_h = 9;
button_lead_r = 1.5;
button_plunger_r = 8.2;
button_plunger_slide_h = 3;

// Arduino micro dimensions
board_x = 18.6;
board_y = 33.6;
board_z = 1.6;
board_lift_z = 3;
board_micro_usb_x = 7.5;
board_micro_usb_y = 2;
board_micro_usb_z = 2.4;

// Wedge, which sits between the two button cases.
wedge_angle = 15;
wedge_y = case_y * cos(wedge_angle);

module block(y) {
    hull() {
        translate([0, -y/2, small_r]) rotate([0, 90, 0])
            cylinder(h=case_x, r=small_r, center=true);
        translate([0, y/2, small_r]) rotate([0, 90, 0])
            cylinder(h=case_x, r=small_r, center=true);
        translate([0, y/2, small_r+vdist]) rotate([0, 90, 0])
            cylinder(h=case_x, r=small_r, center=true);
    }
}

module divot_posts() {
    module corner_stone() {
        cube([30, 6, 100], center=true);
    } 
    intersection() {
        reflect_x() union() {
            translate([case_x/2, case_y/2+2, -2])
                rotate([0, 0, 135]) corner_stone();
            translate([case_x/2, -(case_y/2+2), -2])
                rotate([0, 0, 45]) corner_stone();
        }
        hull() whole_case();
    }
}

module divots(r) {
    $fn=10;
    case_x2=case_x; // 3.5;
    case_y2=case_y+4; // 5;
    reflect_xy() union() {
        translate([case_x2/2, case_y2/2, 0]) sphere(r);
    }
}

module mink_it(sphere_r) {
    $fn=10;
    minkowski() {
        children(0);
        sphere(r=sphere_r);
    }
}

module mink_it_hollow() {
    difference() {
        mink_it(3) children(0);
        mink_it(1) children(0);
    }
}

module neg_button_leads() {
    offset_x = 2.5;
    offset_y = 15 / 2 - 1.5;
    reflect_xy()
        translate([offset_x, offset_y, 0])
            cylinder(h=100, r=button_lead_r, center=true, $fn=8);
}

module button_mount() {
    outer_block_h = button_floor_z + 4;
    top_cutout_h = 4;
    bottom_cutout_h = outer_block_h - wall - top_cutout_h;
    extra_bottom = 30;
    extra_x = 26;
    $fn=10;
    difference() {
      translate([0, 0, outer_block_h/2-extra_bottom/2-wall])
        minkowski() {
            cube([button_x, button_y, outer_block_h+extra_bottom], center=true);
            sphere(wall);
        }
      // Top cut-out.
      translate([0, 0, top_cutout_h/2+(outer_block_h-top_cutout_h)])
        scale([1, 1, 1+epsilon])
            cube([button_x, button_y, top_cutout_h], center=true);

      // Bottom cut-out.
      translate([0, 0, bottom_cutout_h/2-extra_bottom/2-wall])
        scale([1, 2, 1+epsilon])
            cube([button_x, button_y, top_cutout_h+extra_bottom], center=true);

      // Lead cut-outs.
      neg_button_leads();
    }
}

module neg_button_plunger() {
    cylinder(h = 100, r=button_plunger_r, center=true);
}

module whole_case() {
    mink_it_hollow() block(case_y);
}

module case_bottom_flat() {
  module bottom_side() {
    difference() {
       whole_case();
       
       // Cut off the top of the case.
       translate([0, 0, 25+small_r])
         cube([100, 100, 50], center=true);
        
       bottom_slots(case_y);
    }
  }
  union() {
      clipped_union() {
          bottom_side();
          divot_posts();
      }

     // Add positive divots.
     translate([0, 0, small_r])
        divots(1);
  }
}

module clipped_union() {
  union() {
       children(0);
       intersection() {
         hull() children(0);
         children(1);
       }
   }
}

module union_clipped_by() {
  union() {
       children(0);
       intersection() {
         hull() children(2);
         children(1);
       }
   }
}

module position_arduino_micro_bracket() {
  translate([0, case_y/2+wall+1/2, -(1+epsilon)]) children(0);
}

module case_bottom_with_arduino_mount() {
  union_clipped_by() {
      case_bottom_flat();
      position_arduino_micro_bracket() arduino_micro_bracket();
      whole_case();
  }
}

module bottom_slots(y) {
    slot_xs = [-40, -30, -20, -10, 0, 10, 20, 30, 40];
    module slot() {
        hull() {
            translate([0, -0.45*y, 0]) cylinder(h=10, r=2.5, center=true);
            translate([0, -5, 0]) cylinder(h=10, r=2.5, center=true);
        }
    }
    for (slot_x = slot_xs) {
        translate([slot_x, 0, 0]) reflect_y() slot();
    }
}

module case_bottom_and_button_mount(button_xs) {
    union_clipped_by() {
        translate([0, 0, case_offset_z])
            rotate([-slope, 0, 0])
                case_bottom_with_arduino_mount(); 

        for (button_x = button_xs) {
            translate([button_x, button_y, 0])
                button_mount();
        }

        // Clip the button mounts within the whole case.
        translate([0, 0, case_offset_z])
            rotate([-slope, 0, 0])
                whole_case();
    }
}

module case_top_flat() {
    module top_side() {
        difference() {
           whole_case();
           
           // Cut off the bottom of the case.
           translate([0, 0, -25+small_r])
             cube([100, 100, 50], center=true);
        }
    }
    difference() {
        clipped_union() {
            top_side();
            divot_posts();
        }
        position_arduino_micro_bracket()
            arduino_micro_bracket_usb_cutout();
        // Add negative divots.
        translate([0, 0, small_r]) divots(1.5);
    }
}

module case_wire_hole() {
    translate([0, 24, 5]) rotate([0, 90, 0])
        cylinder(h = 100, r=3, center=true);
}

module case_top(button_xs) {
  difference() {
    union() {
        clipped_union() {
            translate([0, 0, case_offset_z])
                rotate([-slope, 0, 0])
                    case_top_flat(); 
            for (button_x = button_xs) {
                z = 10+case_offset_z;
                translate([button_x, button_y, z+button_plunger_slide_h/2])
                    cylinder(h=button_plunger_slide_h, r=button_plunger_r+wall, center=true);
            }
        }
        
        // Rib for strength across the middle.
        translate([0, 0, 9+case_offset_z]) rotate([-slope, 0, 0])
            cube([case_x+wall, wall, 4], center=true);
    }

    for (button_x = button_xs) {
        translate([button_x, button_y, 0])
            neg_button_plunger();
    }

    difference() {
        translate([0, 0, case_offset_z+10]) bottom_slots(case_y);
        for (button_x = button_xs) {
            translate([button_x, button_y, 0])
                cylinder(h=100, r=button_plunger_r+wall*1.5, center=true);
        }
    }
    
    // Leave a hole for wires to get in on the side.
    case_wire_hole();
  }
}

module arduino_micro_bracket_usb_cutout() {
    $fn=16;
    cutout_z = 5;
    offset_z = board_lift_z+board_z+board_micro_usb_z/2+1;
    scale([1, 4, 1]) translate([0, 0, offset_z]) union() {
        rotate([90, 0, 0]) hull() {
            reflect_x() translate([(board_micro_usb_x-wall)/2, 0, 0])
                cylinder(h=2*wall, r=wall, center=true);
        }
        translate([0, 0, -cutout_z/2])
            cube([board_micro_usb_x+wall, 2*wall, cutout_z], center=true);
    }
}

module arduino_micro_bracket() {
    $fn=16;
    corner_length=4;
    corner_height = 6;

    module front_bracket() {
        translate([wall/2, -(corner_length/2+1), 0])
            cube([wall, corner_length, corner_height], center=true);
    }

    module back_corner_bracket() {
        translate([1, -1, 0]) union() {    
            translate([0, wall, 0])
                cube([wall, corner_length, corner_height], center=true);
            rotate([0, 0, 90]) translate([0, wall, 0])
                cube([wall, corner_length, corner_height], center=true);
            cylinder(h=corner_height, r=1, center=true);
        }
    }

    reflect_x() translate([board_x/2, -board_y, corner_height/2])
      back_corner_bracket();

    reflect_x() translate([board_x/2, 0, corner_height/2])
      front_bracket();

    module phantom_board() {
        board_micro_usb_overhang = 6;
        translate([0, -board_y/2, board_z/2])
          cube([board_x, board_y, board_z], center=true);
        translate([0, -(board_micro_usb_overhang-board_micro_usb_y)/2, board_z+board_micro_usb_z/2])
          cube([board_micro_usb_x, board_micro_usb_y+board_micro_usb_overhang, board_micro_usb_z], center=true);
    }

    translate([0, 0, board_lift_z]) %phantom_board();

    // A strut to lay the board on.
    reflect_x() translate([+4, -board_y/2+wall/2, board_lift_z/2]) 
        cube([wall, board_y+wall, board_lift_z], center=true);
}

module rotate_on_offset(offset) {
    translate([0, -offset, 0])
        rotate([0, 0, -wedge_angle])
            translate([0, offset, 0])
                children(0);
}

module reflect_x() {
    union() {
        children(0);
        mirror([1, 0, 0]) children(0);
    }
}

module reflect_y() {
    union() {
        children(0);
        mirror([0, 1, 0]) children(0);
    }
}

module reflect_xy() {
    reflect_x() reflect_y() children(0);
}

module wedge() {
    rotate([-slope, 0, 0]) difference() {
        mink_it_hollow() difference() {
            block(wedge_y);

            reflect_x() rotate_on_offset(70)
                translate([100, 0, 0]) cube([200, 200, 100], center=true);
        }
    }
}

module case_wedge() {
    difference() {
        wedge();

        // Leave a hole for wires to get in on the side.
        case_wire_hole();
        
        difference() {
            union() {
                rotate([-slope, 0, 0]) bottom_slots(wedge_y);
                translate([0, 0, case_offset_z+10]) bottom_slots(wedge_y);
            }
            slot_mask();
        }
    }
}

module slot_mask() {
    reflect_x() rotate_on_offset(60)
        translate([100, 0, 0]) cube([200, 200, 100], center=true);
}

module wedge_divot_y() {
    translate([-1, +wedge_y/2+4, 0]) children(0);
    translate([-1, -wedge_y/2+1, 0]) children(0);
}

module case_wedge_with_divot_posts() {
    clipped_union() {
        rotate([slope, 0, 0]) case_wedge();
        reflect_x() rotate_on_offset(70)
            wedge_divot_y() cylinder(h = 100, r=3, center=true);
    }
}

module wedge_top() {
    clipped_union() {
        difference() {
            case_wedge_with_divot_posts();

            // Cut off the bottom of the case.
            translate([0, 0, -25+small_r])
               cube([100, 100, 50], center=true);

            // Cut out the negative divots.
            reflect_x() rotate_on_offset(70) wedge_divot_y()
                translate([0, 0, 2]) sphere(1.5, $fn=10);
        }
        
        // Rib for strength across the middle.
        translate([0, -wall, 9+case_offset_z])
            cube([case_x+wall, wall, 4], center=true);
    }
}

module wedge_bottom() {
    union() {
        difference() {
            case_wedge_with_divot_posts();

            // Cut off the top of the case.
            translate([0, 0, 25+small_r])
               cube([100, 100, 50], center=true);
        }
        // Add in the positive divots.
        reflect_x() rotate_on_offset(70) wedge_divot_y()
            translate([0, 0, 2]) sphere(1, $fn=10);
    }
}

module position_button_case() {
    translate([case_x/2+7, small_r+1, -case_offset_z])
        rotate([slope, 0, 0]) children(0);
}

module button_case_top() {
    position_button_case() case_top(button_xs);
}

module button_case_bottom() {
    position_button_case() case_bottom_and_button_mount(button_xs);
}

module full_case_top() {
    wedge_top();
    reflect_x() rotate_on_offset(70) button_case_top();
}

module full_case_bottom() {
    wedge_bottom();
    reflect_x() rotate_on_offset(70) button_case_bottom();
}

module full_case(z_spread) {
    translate([0, 0, z_spread]) full_case_top();
    full_case_bottom();
}

full_case(30);

/*
// Hack to adjust the height of the buttons - glue them into mount.
module button_mount_height_adjustment() {
    adjustment_height = 1;
    intersection() {
        union() {
            cube([2, 100, adjustment_height], center=true);
            cube([100, 8, adjustment_height], center=true);
        }
        translate([0, button_y/4, 0])
            cube([button_x-1, button_y/2, 100], center=true);
    }
}
/*
union() {
    button_mount_height_adjustment();
    %button_mount();
}
*/