/* This tests the responsiveness and accuracy of the suppression technique
 * implementing RMS detection and frequency shifting within individual bands.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

bands = 11;
response = .05; // in seconds
su_unit(response, x) = freq_shift(dt.rms(response, x) * 10, x);
on = checkbox("active");
gain = hslider("gain", 1, 0, 64, .001);
process(in) = in1 : dt.bpbank(bands) : par(i, bands, su_unit(response)) :> *(on) + 
    in1 * (1 - on)
with {
    in1 = in * gain;
};

