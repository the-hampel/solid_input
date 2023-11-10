import numpy as np

from triqs_dft_tools.sumk_dft import *
from triqs_dft_tools.converters.vasp import *
import triqs_dft_tools.converters.plovasp.converter as plo_converter


# Generate and store PLOs in xml
plo_converter.generate_and_output_as_text('plo.cfg', vasp_dir='./')

# run the converter to h5
conv = VaspConverter('vasp')
conv.convert_dft_input()

sk = SumkDFT(hdf_file='vasp.h5')
