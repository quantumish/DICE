
import matplotlib.pyplot as plt
import click


@click.command()
@click.option('-i', 'infile', help='File to open')
@click.option('--lim', default=False, is_flag=True)
# @click.option('--legacy', default=False, is_flag=True, help='Whether to parse results w/ legacy mode.')
def main(infile, lim# , legacy
         ):
    vals = [float(x) for x in open(infile, "r").readlines()]
    lim = 10 if lim else len(vals)
    plt.plot([2015 + (10*i) for i in range(lim)], vals[:lim])
    plt.xlabel("Year")
    plt.show()

if __name__ == '__main__':
    main()
