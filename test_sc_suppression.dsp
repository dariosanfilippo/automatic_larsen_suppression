/* This tests the responsiveness and accuracy of the suppression technique
 * implementing spectral centroid detection and notch filtering suppression.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

response = .05; // in seconds
in = os.osc(freq);
freq = hslider("Freq", 1000, 20, 20000, .001);
process = in : su.notch(1000, dt.sc(1, response, in));
