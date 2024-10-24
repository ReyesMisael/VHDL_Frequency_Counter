import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
File_name = "27___17__1uS.txt"
archivo = pd.read_csv(File_name)
nx = archivo["nx(i)"]
no = archivo["no(i)"]
fo = 25000000
To = 1/(fo)
tx = 3.14159
fx = 1/(nx/no*To)
#plt.scatter(range(len(archivo["no(i)"])), archivo["nx(i)"], color = 'r')
plt.plot(archivo["nx(i)"],color = 'r')
plt.plot(archivo["no(i)"],color = 'b')
plt.legend(["nx", "no"])
plt.title('Número de conteos') 
plt.xlabel('Coincidencia (i)') 
plt.ylabel('Número de conteos') 
plt.grid()
plt.figure()
plt.plot(fx)
plt.title('Frecuencia Estimada') 
plt.xlabel('Coincidencia (i)') 
plt.ylabel('Frequency Estimation')
plt.grid()
plt.figure()
#plt.plot(abs(tx-10000000)/10000000)
plt.plot(no/nx)
plt.title('no/nx') 
plt.xlabel('Coincidenceia (i)') 
plt.ylabel('Error')
plt.grid()
plt.show()
