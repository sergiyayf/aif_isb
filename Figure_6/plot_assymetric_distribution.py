import numpy as np
from auxiliary.asymmetric_kde import ImproperGammaEstimator
import matplotlib as mpl
mpl.use('TKAgg')
import matplotlib.pyplot as plt
from scipy.stats import lognorm, gaussian_kde
from chist import width as w

pulled_r = w.pull_histories_together('random_switching_new', clone_type='red')
width=pulled_r.iloc[[10]].values[0]
non_nan_width =width[~np.isnan(width)]
print(non_nan_width)

# Generate 500 samples
distribution = lognorm(1, scale=np.exp(1))
samples = distribution.rvs(500)
print(non_nan_width)
print(samples)
# Use an improper gamma estimator with plugin bandwidth estimation
#ige = ImproperGammaEstimator(samples, 'plugin')
ige = ImproperGammaEstimator(non_nan_width, 0.05)
# Plot the resulting density
x = np.linspace(0, 15, 400)
plt.plot(x, ige(x), label='ImproperGammaEstimator')

# Plot the true density
#plt.plot(x, distribution.pdf(x), label='LogNormal(1,1)')

# Plot a naive Gaussian estimate
kde = gaussian_kde(samples)
#plt.plot(x, kde(x), label='gaussian_kde')
plt.legend()
#plt.savefig('example.png')
fig, ax = plt.subplots()
colors = [plt.get_cmap("Reds")(x) for x in np.linspace(0.1, 1, 10)]
for idx, loc in enumerate(range(10,101,10)):
    x=pulled_r.iloc[[loc]]
    width_array = x.values[0][~np.isnan(x.values[0])]
    ige = ImproperGammaEstimator(width_array, .25)
    # Plot the resulting density
    x = np.linspace(0, 15, 400)
    ax.plot(x, ige(x), color=colors[idx])

plt.show()
