/* This tests the responsiveness and accuracy of the suppression technique
 * implementing spectral centroid detection and notch filtering suppression.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

response = .05; // in seconds
in = os.osc(freq);
freq = hslider("Freq", 1000, 20, 20000, .001);
on = checkbox("active");
spec_cent = dt.sc(2, response, in) : dt.inspect(0, 0, 20000);
process = (in : su.notch(1000, spec_cent)) * on + in * (1 - on);
