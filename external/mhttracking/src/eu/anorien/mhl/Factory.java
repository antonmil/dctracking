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

package eu.anorien.mhl;

import eu.anorien.mhl.generator.GeneratedHypotheses;
import eu.anorien.mhl.generator.GeneratedHypothesis;
import eu.anorien.mhl.generator.HypothesesGenerator;
import eu.anorien.mhl.pruner.PrunerFactory;
import java.util.Collection;
import java.util.Set;

/**
 * <p>The Factory allows the application to create the necessary data structures
 * for using the library.</p>
 *
 * @author David Miguel Antunes davidmiguel [ at ] antunes.net
 */
public interface Factory {

    public HypothesesManager newHypothesesManager();

    /**
     * Creates a new GeneratedHypothesis object which should be returned to the
     * library when returning from the {@link HypothesesGenerator#generate(java.util.Set, java.util.Set) generate}
     * method of the HypothesesGenerator class.
     *
     * @param hypotheses The generated hypotheses.
     */
    public GeneratedHypotheses newGeneratedHypotheses(Collection<GeneratedHypothesis> hypotheses);

    /**
     * Creates a new generated hypothesis.
     * @param probability The hypothesis probability.
     * @param events The new generated events.
     * @param facts The new generated facts.
     * @return The generated hypothesis.
     */
    public GeneratedHypothesis newGeneratedHypothesis(double probability, Set<Event> events, Set<Fact> facts);

    /**
     * @return A factory of pruners.
     */
    public PrunerFactory getPrunerFactory();
}
