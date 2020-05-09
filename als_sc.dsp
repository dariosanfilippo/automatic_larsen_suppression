/* Automatic Larsen Suppression system through spectral centroid calculation and
 * adaptive notch filtering.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

declare name "ALS (SC) - Automatic Larsen Suppression";
declare author "Dario Sanfilippo";
declare copyright "Copyright (C) 2020 Dario Sanfilippo <sanfilippo.dario@gmail.com>";
declare version "1.00";
declare license "GPL v3.0 license";

// signal inspector
inspect = _ <: attach(  _ ,
                        _ : 
    vbargraph("Spectral centroid [style:numerical]", 0, 48000));

on = checkbox("[0]Active");
memory = checkbox("[1]Memory");
freeze = 1 - checkbox("[2]Freeze");
gain = hslider("[3]Input gain (dB)", 0, -64, 64, .001) : ba.db2linear;
response = hslider("[4]Responsiveness (seconds)", .1, .01, 1, .001);
q = hslider("[5]Selectiveness (Q factor)", 1, .1, 10, .001);
vol = hslider("[6]Output volume (linear)", 0, 0, 1, .001);
spec_cent(in) = dt.sc(2, memory, response, in) : ba.sAndH(freeze) : inspect;
suppressor(in) = su.notch2(spec_cent(in), q, in);
als_sc(in) = suppressor(in1) * on + in1 * (1 - on) * vol
with {
    in1 = in * gain;
};
process = als_sc;
