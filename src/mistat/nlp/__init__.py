import gzip
from pathlib import Path

DEMO_FILE_DIR = Path(__file__).parent


def _readFile(filename):
    with gzip.open(filename) as f:
        return f.read().decode('utf-8')


def globalWarmingBlogs():
    return {
        # https://www.tomorrow.io/weather/blog/global-warming-status/
        'blog-1': _readFile(DEMO_FILE_DIR / 'global-warming-blog-1.txt.gz'),
        # https://blogs.scientificamerican.com/plugged-in/global-warming-explained-in-under-a-minute/
        'blog-2': _readFile(DEMO_FILE_DIR / 'global-warming-blog-2.txt.gz'),
    }


def covid19Blogs():
    """ Three covid-19 related blog posts from Eduardo Levy Yeyati """
    return {
        # https://www.brookings.edu/research/social-and-economic-impact-of-covid-19/
        'blog-1': _readFile(DEMO_FILE_DIR / 'covid-19-blog-1.txt.gz'),
        # https://www.brookings.edu/opinions/the-covid-reset-latin-america-needs/
        'blog-2': _readFile(DEMO_FILE_DIR / 'covid-19-blog-2.txt.gz'),
        # https://voxeu.org/article/covid-19-americas-north-south-differences-and-labour-market-channel
        'blog-3': _readFile(DEMO_FILE_DIR / 'covid-19-blog-3.txt.gz'),
    }
