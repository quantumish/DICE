
import matplotlib.pyplot as plt
import click


@click.command()
@click.option('-i', 'infile', help='File to open')
@click.option('--legacy', default=False, is_flag=True, help='Whether to parse results w/ legacy mode.')
def main(infile, legacy):
    vals = [float(x) for x in open(infile, "r").read().split()]
    plt.plot(vals)
    plt.show()

if __name__ == '__main__':
    main()
