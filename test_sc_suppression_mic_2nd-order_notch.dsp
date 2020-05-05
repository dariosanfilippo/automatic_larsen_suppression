/* This tests the responsiveness and accuracy of the suppression technique
 * implementing spectral centroid detection and notch filtering suppression.
 */

import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");

response = .05; // in seconds
on = checkbox("active");
process(in) = (in : su.notch(1000, dt.sc(2, response, in))) * on + in * (1 - on);
