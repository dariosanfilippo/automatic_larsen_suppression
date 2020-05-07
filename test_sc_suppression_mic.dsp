/* This tests the responsiveness and accuracy of the suppression technique
 * implementing spectral centroid detection and 1st-order notch filtering suppression.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

on = checkbox("active");
gain = hslider("gain", 1, 0, 64, .001);
vol = hslider("vol", 1, 0, 64, .001);
response = hslider("response", .1, .001, 1, .001); // in seconds
spec_cent(in) = dt.sc(2, response, in) : dt.inspect(0, 0, 20000);
process(in) = ((in1 : su.phase_invert(spec_cent(in1)) + in1) / 2 * 
    on + in1 * (1 - on)) * vol
with {
    in1 = in * gain;
};

