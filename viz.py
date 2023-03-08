
import matplotlib.pyplot as plt
import click


@click.command()
@click.option('-i', 'infile', help='File to open')
# @click.option('--legacy', default=False, is_flag=True, help='Whether to parse results w/ legacy mode.')
def main(infile# , legacy
         ):
    vals = [float(x) for x in open(infile, "r").readlines()]
    plt.plot(vals)
    plt.ylabel("Temperature (deviation from pre-industrial)")
    plt.xlabel("Time (decades?)")
    plt.show()

if __name__ == '__main__':
    main()
