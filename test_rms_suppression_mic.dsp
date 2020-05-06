/* This tests the responsiveness and accuracy of the suppression technique
 * implementing RMS detection and frequency shifting.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

response = .1; // in seconds
on = checkbox("active");
gain = hslider("gain", 1, 0, 64, .001);
process(in) = su.freq_shift(dt.rms(response, in1) * 10, in1) * on + 
    in1 * (1 - on)
with {
    in1 = in * gain;
};

