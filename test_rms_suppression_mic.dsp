/* This tests the responsiveness and accuracy of the suppression technique
 * implementing RMS detection and frequency shifting.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

on = checkbox("active");
gain = hslider("gain", 1, 0, 64, .001);
vol = hslider("vol", 1, 0, 1, .001);
response = hslider("response", .1, .001, 1, .001); // in seconds
process(in) = (su.freq_shift(dt.rms(response, in1) * 10, in1) * on + 
    in1 * (1 - on)) * vol
with {
    in1 = in * gain;
};

