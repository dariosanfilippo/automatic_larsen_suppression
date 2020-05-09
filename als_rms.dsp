/* Automatic Larsen Suppression system through RMS calculation and
 * adaptive frequency shifting.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

declare name "ALS (RMS) - Automatic Larsen Suppression";
declare author "Dario Sanfilippo";
declare copyright "Copyright (C) 2020 Dario Sanfilippo <sanfilippo.dario@gmail.com>";
declare version "1.00";
declare license "GPL v3.0 license";

// signal inspector
inspect = _ <: attach(  _ ,
                        _ :
    vbargraph("Frequency shift [style:numerical]", 0, 20));

on = checkbox("[0]Active");
freeze = 1 - checkbox("[1]Freeze");
gain = hslider("[2]Input gain (dB)", 0, -64, 64, .001) : ba.db2linear;
response = hslider("[3]Responsiveness (seconds)", .1, .01, 1, .001);
rms_curve = hslider("[4]RMS curve (log-to-exp)", 0, -1, 1, .001) : (4 , _ : pow);
shift_range = hslider("[4]Effectiveness (shift magnitude)", 1, .1, 10, .001);
vol = hslider("[5]Output volume (linear)", 0, 0, 1, .001);
shift(in) = dt.rms(response, in) : pow(rms_curve) * shift_range : ba.sAndH(freeze) : inspect;
suppressor(in) = su.freq_shift(shift(in), in);
als_rms(in) = suppressor(in) * on + in1 * (1 - on) * vol
with {
    in1 = in * gain;
};
process = als_rms;
