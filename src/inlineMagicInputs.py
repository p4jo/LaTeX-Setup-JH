from argparse import ArgumentParser, FileType, Namespace
from io import TextIOWrapper
import re
from pathlib import Path
VERSION = "0.1.0"

def parse_cmdline_args() -> Namespace:

    parser = ArgumentParser(
        description="Replace magic imports"
    )
    parser.add_argument(
        'file',
        type = FileType(encoding='utf8', mode='r'),
        help='Input file'
    )
    parser.add_argument(
        '-outfile',
        '-o',
        type=str,
        required=False
    )
    parser.add_argument(
        '-ignore',
        '-i',
        action='store_true',
        help='Keep going even when a file is missing'
    )

    parser.add_argument(
        "-v", "--version", 
        action="version",
        version = f"{parser.prog} version {VERSION}"
    )

    return parser.parse_args()

# magic_comment_pattern = re.compile(r'(?<=^%\s!TeX\sinput\s)((?!\s%).)*')
magic_comment_pattern = re.compile(r'^%\s!TeX\sinput\s((?!\s%).)*')
PATTERN_LENGTH = len('% !TeX input ')
def main(file = None, outfile=None, ignore=False):
    input_file_path = Path(file)
    
    if outfile:
        output_file_path = Path(args.outfile)
    else:
        if not input_file_path.suffix.startswith('.m') :
            output_file_path=input_file_path.with_stem(input_file_path.stem+'_inserted')
        else:
            output_file_path = input_file_path.with_suffix('.' + input_file_path.suffix[2:])

    path_relative_to = input_file_path.parent
    
    lines = input_file_path.read_text(encoding='utf8').splitlines()

    output_lines = [f'% Auto generated file, created from {input_file_path}. Will be overwritten. Change the source files instead.']
    for line in lines:
        match = magic_comment_pattern.match(line)
        if not match:
            if not line.startswith('%*'):
                output_lines.append(line)
            continue

        match_text = match.group()
        inserted_file_name = match_text[PATTERN_LENGTH:].strip()
        rest_line = line[len(match_text):]

        if inserted_file_name.startswith('~'):
            inserted_file_name = inserted_file_name[1:].lstrip()
            path_relative_to = Path(inserted_file_name)
            comment = f"Base Path for inserts with % !TeX input set to {path_relative_to}"
            output_lines.append(f'%%% {comment} %%%')
            print(comment)
            continue

        inserted_path = path_relative_to / Path(inserted_file_name)
        
        output_lines.append(
            get_inserted_text(
                ignore,
                inserted_path,
                rest_line
            )
        )

    print(f'Writing file {output_file_path}.')
    output_file_path.write_text('\n'.join(output_lines), encoding='utf8')

def get_inserted_text(ignore, inserted_path, rest_line):
    if not inserted_path.is_file():
        inserted_path = inserted_path.with_suffix('.tex')

        if not inserted_path.is_file():
            error =  f"INSERTED FILE {inserted_path.resolve().absolute()} DOESN'T EXIST"
            print(error)
            if not ignore:
                exit(1)
            return f"%%% {error} %%%"

    print(f"inserted {inserted_path}")
    return f"""
%%% FILE {inserted_path} {rest_line} %%%
{open(inserted_path, mode='r', encoding='utf8').read()}
%%% END OF INSERTED FILE {inserted_path} %%%
"""

if __name__ == '__main__':
    # TEST_FILE =  'JHPreamble.mcls'
    TEST_FILE=None
    if not TEST_FILE:
        args = parse_cmdline_args()
        
        input_file_stream: TextIOWrapper = args.file
        file = input_file_stream.name

        outfile = args.outfile.strip()
        
        main(file=file, outfile=outfile, ignore=args.ignore)
    else:
        main(TEST_FILE)
