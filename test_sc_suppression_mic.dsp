/* This tests the responsiveness and accuracy of the suppression technique
 * implementing spectral centroid detection and 1st-order notch filtering suppression.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

response = .05; // in seconds
on = checkbox("active");
process(in) = (in : su.phase_invert(dt.sc(2, response, in)) + in) / 2 * on + in * (1 - on);

