from chist import width as w
import matplotlib as mpl
mpl.use('TkAgg')
from matplotlib import pyplot as plt

def setup_figure(save_figure=False):
    plt.rcParams.update({'font.size': 6,
                         'font.weight': 'normal',
                         'font.family': 'sans-serif'})
    mpl.rcParams['pdf.fonttype'] = 42  # to make text editable in pdf output
    mpl.rcParams['font.sans-serif'] = ['Arial']  # to make it Arial

    custom_blue = (82 / 255, 175 / 255, 230 / 255)
    custom_red = (190 / 255, 28 / 255, 45 / 255)
    fig, ax = plt.subplots(figsize=(235/72,170/72),constrained_layout=True)
    pulled_r = w.pull_histories_together('random_switching_new', clone_type='red')
    pulled_b = w.pull_histories_together('random_switching_new', clone_type='blue') #random_switching_new

    ax.plot(pulled_b.median(axis=1), color=custom_blue)
    ax.plot(pulled_b.mean(axis=1), color=[35 / 255, 109 / 255, 200 / 255])
    ax.fill_between(pulled_b.index, pulled_b.quantile(q=0.25,axis=1),
                    pulled_b.quantile(q=0.75,axis=1), color=custom_blue,alpha=0.5)
    ax.plot(pulled_r.median(axis=1), color=custom_red, label='Median')
    ax.plot(pulled_r.mean(axis=1), color=[120 / 255, 28 / 255, 45 / 255], label='Mean')
    ax.fill_between(pulled_r.index, pulled_r.quantile(q=0.25,axis=1),
                    pulled_r.quantile(q=0.75,axis=1), color=custom_red,alpha=0.5)
    #ax.grid(True, linestyle='--', color='grey')
    ax.set_ylim([0,15])
    ax.legend()
    fig.set_constrained_layout_pads(w_pad=10 / 72, h_pad=10 / 72, hspace=2 / 72, wspace=2 / 72)
    if save_figure:
        fig.savefig('width_and_median_random_median.pdf',transparent=True)

    plt.show()


if __name__ == "__main__":
    setup_figure(save_figure=False)