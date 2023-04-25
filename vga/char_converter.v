module char_converter(input[7:0] hour, minute, input ampm, output[7:0] dig1, dig2, dig3, dig4, dig5, dig6, colon);
    wire [7:0] min0, min1, min2, min3, min4, min5, min6, min7, min8, min9, min10, 
    min11, min12, min13, min14, min15, min16, min17, min18, min19, min20, 
    min21, min22, min23, min24, min25, min26, min27, min28, min29, min30, 
    min31, min32, min33, min34, min35, min36, min37, min38, min39, min40, 
    min41, min42, min43, min44, min45, min46, min47, min48, min49, min50, 
    min51, min52, min53, min54, min55, min56, min57, min58, min59,
    hour10, hour11, hour12,
    dig4_0, dig4_1, dig4_2, dig4_3, dig4_4, dig4_5, dig4_6, dig4_7, dig4_8, dig4_9,
    dig3_0, dig3_1, dig3_2, dig3_3, dig3_4, dig3_5;

    wire NIL;
    assign NIL = hour == 8'd0 && minute == 8'd0;
    assign colon = NIL? 8'd12: 8'd10;

    assign hour10 = hour == 8'd10;
    assign hour11 = hour == 8'd11;
    assign hour12 = hour == 8'd12;

    assign dig1 = NIL? 8'd12: hour10 || hour11 || hour12? 8'd1: 8'd0;
    assign dig2 = NIL? 8'd12: hour10? 8'd0: hour11? 8'd1: hour12? 8'd2: hour;

    assign min0 = minute == 8'd0;
    assign min1 = minute == 8'd1;
    assign min2 = minute == 8'd2;
    assign min3 = minute == 8'd3;
    assign min4 = minute == 8'd4;
    assign min5 = minute == 8'd5;
    assign min6 = minute == 8'd6;
    assign min7 = minute == 8'd7;
    assign min8 = minute == 8'd8;
    assign min9 = minute == 8'd9;
    assign min10 = minute == 8'd10;
    assign min11 = minute == 8'd11;
    assign min12 = minute == 8'd12;
    assign min13 = minute == 8'd13;
    assign min14 = minute == 8'd14;
    assign min15 = minute == 8'd15;
    assign min16 = minute == 8'd16;
    assign min17 = minute == 8'd17;
    assign min18 = minute == 8'd18;
    assign min19 = minute == 8'd19;
    assign min20 = minute == 8'd20;
    assign min21 = minute == 8'd21;
    assign min22 = minute == 8'd22;
    assign min23 = minute == 8'd23;
    assign min24 = minute == 8'd24;
    assign min25 = minute == 8'd25;
    assign min26 = minute == 8'd26;
    assign min27 = minute == 8'd27;
    assign min28 = minute == 8'd28;
    assign min29 = minute == 8'd29;
    assign min30 = minute == 8'd30;
    assign min31 = minute == 8'd31;
    assign min32 = minute == 8'd32;
    assign min33 = minute == 8'd33;
    assign min34 = minute == 8'd34;
    assign min35 = minute == 8'd35;
    assign min36 = minute == 8'd36;
    assign min37 = minute == 8'd37;
    assign min38 = minute == 8'd38;
    assign min39 = minute == 8'd39;
    assign min40 = minute == 8'd40;
    assign min41 = minute == 8'd41;
    assign min42 = minute == 8'd42;
    assign min43 = minute == 8'd43;
    assign min44 = minute == 8'd44;
    assign min45 = minute == 8'd45;
    assign min46 = minute == 8'd46;
    assign min47 = minute == 8'd47;
    assign min48 = minute == 8'd48;
    assign min49 = minute == 8'd49;
    assign min50 = minute == 8'd50;
    assign min51 = minute == 8'd51;
    assign min52 = minute == 8'd52;
    assign min53 = minute == 8'd53;
    assign min54 = minute == 8'd54;
    assign min55 = minute == 8'd55;
    assign min56 = minute == 8'd56;
    assign min57 = minute == 8'd57;
    assign min58 = minute == 8'd58;
    assign min59 = minute == 8'd59;




    assign dig4_0 = min0 || min10 || min20 || min30 || min40 || min50;
    assign dig4_1 = min1 || min11 || min21 || min31 || min41 || min51;
    assign dig4_2 = min2 || min12 || min22 || min32 || min42 || min52;
    assign dig4_3 = min3 || min13 || min23 || min33 || min43 || min53;
    assign dig4_4 = min4 || min14 || min24 || min34 || min44 || min54;
    assign dig4_5 = min5 || min15 || min25 || min35 || min45 || min55;
    assign dig4_6 = min6 || min16 || min26 || min36 || min46 || min56;
    assign dig4_7 = min7 || min17 || min27 || min37 || min47 || min57;
    assign dig4_8 = min8 || min18 || min28 || min38 || min48 || min58;
    assign dig4_9 = min9 || min19 || min29 || min39 || min49 || min59;

    assign dig3_0 = min1 || min2 || min3 || min4 || min5 || min6 || min7 || min8 || min9;
    assign dig3_1 = min10 || min11 || min12 || min13 || min14 || min15 || min16 || min17 || min18 || min19;
    assign dig3_2 = min20 || min21 || min22 || min23 || min24 || min25 || min26 || min27 || min28 || min29;
    assign dig3_3 = min30 || min31 || min32 || min33 || min34 || min35 || min36 || min37 || min38 || min39;
    assign dig3_4 = min40 || min41 || min42 || min43 || min44 || min45 || min46 || min47 || min48 || min49;
    assign dig3_5 = min51 || min52 || min53 || min54 || min55 || min56 || min57 || min58 || min59;

    assign dig3 = NIL? 8'd12: dig3_0 ? 8'd0: dig3_1? 8'd1: dig3_2? 8'd2: dig3_3? 8'd3: dig3_4? 8'd4: dig3_5? 8'd5: 8'd0;
    assign dig4 = NIL? 8'd12: dig4_0 ? 8'd0: dig4_1? 8'd1: dig4_2? 8'd2: dig4_3? 8'd3: dig4_4? 8'd4: dig4_5? 8'd5: dig4_6 ? 8'd6: dig4_7? 8'd7: dig4_8? 8'd8: dig4_9? 8'd9: 8'd0;

    assign dig5 = NIL? 8'd12: ampm? 8'd100: 8'd115;
    assign dig6 = NIL? 8'd12: 8'd112;

endmodule