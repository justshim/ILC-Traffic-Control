import cell as c
import supervisor as s


stretch1 = s.Stretch()
stretch1.createCell(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
stretch1.createCell(10, 11, 12, 13, 14, 15, 16, 17, 18, 19)

print("**********\nStretch 1\n**********")
print(stretch1.n_cells)
print()

for cell in stretch1.cells:
	cell.toString()
	print()

stretch2 = s.Stretch()
stretch2.createCell(20, 21, 22, 23, 24, 25, 26, 27, 28, 29)
stretch2.createCell(30, 31, 32, 33, 34, 35, 36, 37, 38, 39)
stretch2.createCell(40, 41, 42, 43, 44, 45, 46, 47, 48, 49)

stretch2.createStation(1, 2, 3)
stretch2.createStation(11, 22, 33)

stretch2.stations[0].createService(1,2)
stretch2.stations[0].createService(88,888)
stretch2.stations[1].createService(99,999)

print("**********\nStretch 2\n**********")
print(stretch2.n_cells)
print()

for cell in stretch2.cells:
	cell.toString()
	print()

print("====================")

for station in stretch2.stations:
	station.toString()
	print()	

print("====================")

for station in stretch2.stations:
	for i in range(len(station.services)):
		station.services[i].toString()
		print()
