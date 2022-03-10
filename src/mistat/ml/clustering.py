'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import numpy as np
from scipy.cluster.hierarchy import dendrogram, fcluster


def plot_dendrogram(model, **kwargs):
    # Create linkage matrix and then plot the dendrogram

    # create the counts of samples under each node
    counts = np.zeros(model.children_.shape[0])
    n_samples = len(model.labels_)
    for i, merge in enumerate(model.children_):
        current_count = 0
        for child_idx in merge:
            if child_idx < n_samples:
                current_count += 1  # leaf node
            else:
                current_count += counts[child_idx - n_samples]
        counts[i] = current_count

    linkage_matrix = np.column_stack([model.children_, model.distances_,
                                      counts]).astype(float)

    threshold = kwargs.get('color_threshold')
    if threshold is None and model.n_clusters_ is not None:
        # find threshold for given number of clusters
        threshold = np.max(model.distances_) / 2
        delta = threshold / 2
        while True:
            count = len(set(fcluster(linkage_matrix, t=threshold, criterion='distance')))
            if count == model.n_clusters_:
                break
            if count > model.n_clusters_:
                threshold = threshold + delta
            else:
                threshold = threshold - delta
            delta = delta / 2

    # Plot the corresponding dendrogram
    dendrogram(linkage_matrix, color_threshold=threshold, **kwargs)
