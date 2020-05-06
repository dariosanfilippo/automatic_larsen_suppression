/* This tests the responsiveness and accuracy of the suppression technique
 * implementing spectral centroid detection and notch filtering suppression.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

response = .1; // in seconds
on = checkbox("active");
gain = hslider("gain", 1, 0, 64, .001);
process(in) = (in1 : su.notch(1000, dt.sc(2, response, in1))) * on + 
    in1 * (1 - on)
with {
    in1 = in * gain;
};
