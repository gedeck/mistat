""" Accompanying source code for

Ron Kenett, Shelemyahu Zacks, Peter Gedeck
- Modern Statistics: A Computer Based Approach with Python
- Industrial Statistics: A Computer Based Approach with Python
"""
from .data import describe_data, load_data
from .design import (FDS_Plot, addTreatments, calculateInteractions,
                     calculateMainEffects, getModelMatrix, interactionPlot,
                     mainEffectsPlot, marginalInteractionPlot,
                     subgroupOfDefining, doe)
from .ecdf import plotECDF
from .ml import plot_dendrogram
from .mqcc import MahalanobisT2, MultivariateQualityControlChart
from .qcc import (EWMA, Cusum, ParetoChart, ProcessCapability,
                  QualityControlChart, cusumArl, cusumPfaCed, qcc_groups,
                  qccStatistics, shroArlPfaCedNorm)
from .randomizationTest import randomizationTest
from .regression import stepwise_regression
from .reliability import availabilityEBD, renewalEBD
from .rsm import ResponseSurfaceMethod
from .runsTest import runStatistics, runsTest
from .simulation import (PistonSimulator, PowerCircuitSimulation,
                         SimulationResult, pistonConfigurations,
                         simulationGroup)
from .stem_leaf import stemLeafDiagram
from .timeseries import (dlmLinearGrowth, masPredictor, normRandomWalk,
                         optimalLinearPredictor, predictARMA,
                         quadraticPredictor, simulateARMA)
