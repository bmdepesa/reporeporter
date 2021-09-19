import argparse
import csv
import sys
import openpyxl as px

def main():
	files = ["rke2"]
	parser = argparse.ArgumentParser()
	parser.add_argument("date")
	args = parser.parse_args()

	wb = px.Workbook()

	for file in files:
		curfile = "reports/" + file + "-" + args.date + ".txt"
		ws = wb.create_sheet(file)
		for row in csv.reader(open(curfile), delimiter="\t"):
			ws.append([_convert_to_number(cell) for cell in row])
			ws.auto_filter.ref = ws.dimensions

	wb.remove(wb['Sheet'])
	wb.save("reports/report-" + args.date + ".xlsx")


def _convert_to_number(cell):
	if cell.isnumeric():
		return int(cell)
	try:
		return float(cell)
	except ValueError:
		return cell

main()