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
package eu.anorien.mhl.pruner;

import java.util.List;

/**
 * <p>Creates new pruners.</p>
 * 
 * @author David Miguel Antunes davidmiguel [ at ] antunes.net
 */
public interface PrunerFactory {

    /**
     * Creates a new null pruner. This pruner does not prune any leaves or
     * branches of the tree.
     */
    public Pruner newNullPruner();

    /**
     * Prunes all but the best K leaves of the hypotheses tree.
     * @param k The number of leaves to leave at each hypothesis tree after pruning.
     */
    public Pruner newBestKPruner(int k);

    /**
     * Creates a new tree depth pruner. Does not allow the hypothesis trees to
     * grow beyond the depth provided in the argument.
     * @param depth Maximum depth of the hypothesis tree.
     */
    public Pruner newTreeDepthPruner(int depth);

    /**
     * Applies sequentially a series of pruners.
     */
    public Pruner newCompositePruner(List<Pruner> pruners);

    /**
     * Applies sequentially a series of pruners.
     */
    public Pruner newCompositePruner(Pruner[] pruners);
}
