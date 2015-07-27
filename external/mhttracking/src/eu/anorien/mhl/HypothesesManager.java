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

import eu.anorien.mhl.generator.HypothesesGenerator;
import eu.anorien.mhl.pruner.Pruner;
import eu.anorien.mhl.pruner.PrunerFactory;
import java.util.Collection;
import java.util.Set;

/**
 * This is the class which controls most of the behavior of the library.
 * @author David Miguel Antunes
 */
public interface HypothesesManager {

    /**
     * Register a watcher of the library. It will be notified of changes in the
     * library.
     * @param watcher The watcher to register.
     */
    public void register(Watcher watcher);

    /**
     * Request an hypothesis generation.
     * 
     * @param generator The hypothesis generator which the library will invoke to
     * generate the new hypotheses.
     * @param reqEvents The events which the application needs to be available
     * for this hypothesis generation.
     * @param reqFacts The facts which the application needs to be available
     * for this hypothesis generation.
     */
    public void generateHypotheses(HypothesesGenerator generator, Set<Event> reqEvents, Set<Fact> reqFacts);

    /**
     * Returns the current best Hypothesis.
     * @return The best Hypothesis.
     */
    public Hypothesis getBestHypothesis();

    /**
     * Returns all the hypotheses maintained by the library.
     * @return The all the maintained hypotheses.
     */
    public Collection<Hypothesis> getAllHypotheses();

    /**
     * Sets the pruner which will be used to prune the clusters. If more than
     * one pruning strategy is to be used, you can create a {@link eu.anorien.mhl.pruner.PrunerFactory#newCompositePruner(java.util.List) composite pruner}.
     * @param pruner The new pruner.
     * @see PrunerFactory
     */
    public void setPruner(Pruner pruner);

    /**
     * <p>This predicate is used to identify clusters which will never be requested
     * in the context of an hypothesis generation. These clusters occupy memory
     * space needlessly and, ultimately, the application may crash without
     * memory.</p>
     * @param requiredPredicate The new predicate.
     */
    public void setRequiredPredicate(MayBeRequiredPredicate requiredPredicate);
}
