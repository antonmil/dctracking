//Copyright (C) 2011 by David Miguel Antunes davidmiguel [ at ] antunes.net
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

package eu.anorien.mhl.generator;

import eu.anorien.mhl.Event;
import eu.anorien.mhl.Fact;
import eu.anorien.mhl.HypothesesManager;
import java.util.Set;

/**
 * <p>Is invoked by the library to generate hypotheses in an hypothesis
 * generation.</p>
 * 
 * @author David Miguel Antunes
 */
public interface HypothesesGenerator {

    /**
     * <p>Generates a new set of hypotheses, when invoked by the library.</p>
     * 
     * @param provEvents The subset of the requested events (the events requested using the 
     * {@link HypothesesManager#generateHypotheses(eu.anorien.mhl.generator.HypothesesGenerator, java.util.Set, java.util.Set) generateHypotheses}
     * method) which are available at the leaf for which hypotheses are being
     * generated.
     * @param provFacts The subset of the requested facts (the facts requested using the
     * {@link HypothesesManager#generateHypotheses(eu.anorien.mhl.generator.HypothesesGenerator, java.util.Set, java.util.Set) generateHypotheses}
     * method) which are available at the leaf for which hypotheses are being
     * generated.
     */
    public GeneratedHypotheses generate(Set<Event> provEvents, Set<Fact> provFacts);
}
