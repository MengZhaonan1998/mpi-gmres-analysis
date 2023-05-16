# first:
#module load 2022r2
#module load openmpi

CXX=mpic++
#CXX_FLAGS=-O2 -g -fopenmp -std=c++17
CXX_FLAGS=-O3 -march=native -g -fopenmp -std=c++17

#default target (built when typing just "make")
default: run_tests.x main_cg_poisson.x main_gmres_poisson_global.x main_polyg_poisson_global.x main_diagg_poisson_global.x main_gmres_poisson_cart.x main_polyg_poisson_cart.x main_diagg_poisson_cart.x main_gmres_poisson_win.x main_polyg_poisson_win.x main_diagg_poisson_win.x

# general rule to compile a C++ source file into an object file
%.o: %.cpp
	${CXX} -c ${CXX_FLAGS}  $<


#define some dependencies on headers
operations.o: operations.hpp timer.hpp
gmres_solver.o: gmres_solver.hpp operations.hpp timer.hpp
polygmres_solver.o: gmres_solver.hpp operations.hpp timer.hpp
cg_solver.o: cg_solver.hpp operations.hpp timer.hpp
gtest_mpi.o: gtest_mpi.hpp

TEST_SOURCES=test_operations.cpp test_gmres_solver.cpp timer.o gtest_mpi.o operations.cpp gmres_solver.o cg_solver.o
MAIN_CG_OBJ=main_cg_poisson.o cg_solver.o operations.cpp timer.o 

MAIN_GMRES_OBJ=main_gmres_poisson.cpp gmres_solver.o operations.cpp timer.o 
MAIN_DIAGG_OBJ=main_gmres_poisson.cpp gmres_solver.o operations.cpp timer.o
MAIN_POLYG_OBJ=main_gmres_poisson.cpp polygmres_solver.o operations.cpp timer.o

MAIN_GMRES_CART_OBJ=main_gmres_poisson.cpp gmres_solver.o operations.cpp timer.o 
MAIN_DIAGG_CART_OBJ=main_gmres_poisson.cpp gmres_solver.o operations.cpp timer.o
MAIN_POLYG_CART_OBJ=main_gmres_poisson.cpp polygmres_solver.o operations.cpp timer.o

MAIN_GMRES_WIN_OBJ=main_gmres_poisson.cpp gmres_solver.o operations.cpp timer.o 
MAIN_DIAGG_WIN_OBJ=main_gmres_poisson.cpp gmres_solver.o operations.cpp timer.o
MAIN_POLYG_WIN_OBJ=main_gmres_poisson.cpp polygmres_solver.o operations.cpp timer.o
 
run_tests.x: run_tests.cpp ${TEST_SOURCES}
	${CXX} ${CXX_FLAGS} -DSTENCIL_GLOBAL_COMM -DUSE_MPI -o run_tests.x $^

main_cg_poisson.x: ${MAIN_CG_OBJ}
	${CXX} ${CXX_FLAGS} -DSTENCIL_GLOBAL_COMM -o main_cg_poisson.x $^


main_gmres_poisson_global.x: ${MAIN_GMRES_OBJ} 
	${CXX} ${CXX_FLAGS} -DSTENCIL_GLOBAL_COMM -o main_gmres_poisson_global.x $^

main_polyg_poisson_global.x: ${MAIN_POLYG_OBJ} 
	${CXX} ${CXX_FLAGS} -DSTENCIL_GLOBAL_COMM -DUSE_POLY -o main_polyg_poisson_global.x $^

main_diagg_poisson_global.x: ${MAIN_DIAGG_OBJ} 
	${CXX} ${CXX_FLAGS} -DSTENCIL_GLOBAL_COMM -DUSE_DIAG -o main_diagg_poisson_global.x $^


main_gmres_poisson_cart.x: ${MAIN_GMRES_CART_OBJ} 
	${CXX} ${CXX_FLAGS} -DSTENCIL_MPI_CART -o main_gmres_poisson_cart.x $^

main_polyg_poisson_cart.x: ${MAIN_POLYG_CART_OBJ} 
	${CXX} ${CXX_FLAGS} -DSTENCIL_MPI_CART -DUSE_POLY -o main_polyg_poisson_cart.x $^

main_diagg_poisson_cart.x: ${MAIN_DIAGG_CART_OBJ}
	${CXX} ${CXX_FLAGS} -DSTENCIL_MPI_CART -DUSE_DIAG -o main_diagg_poisson_cart.x $^


main_gmres_poisson_win.x: ${MAIN_GMRES_WIN_OBJ} 
	${CXX} ${CXX_FLAGS} -DSTENCIL_ONE_SIDED -o main_gmres_poisson_win.x $^

main_polyg_poisson_win.x: ${MAIN_POLYG_WIN_OBJ} 
	${CXX} ${CXX_FLAGS} -DSTENCIL_ONE_SIDED -DUSE_POLY -o main_polyg_poisson_win.x $^

main_diagg_poisson_win.x: ${MAIN_DIAGG_WIN_OBJ}
	${CXX} ${CXX_FLAGS} -DSTENCIL_ONE_SIDED -DUSE_DIAG -o main_diagg_poisson_win.x $^

test: run_tests.x
	mpirun -np 1  ./run_tests.x
	mpirun -np 8  ./run_tests.x --mca orte_base_help_aggregate 0
	mpirun -np 18 ./run_tests.x --mca orte_base_help_aggregate 0

cg_solver: main_cg_poisson.x
	mpirun -np 1 ./main_cg_poisson.x 64
	mpirun -np 18 ./main_cg_poisson.x 64

gmres_solver: main_gmres_poisson.x
	mpirun -np 1 ./main_gmres_poisson.x 64 4
	mpirun -np 18 ./main_gmres_poisson.x 64 4

clean:
	-rm *.o *.x

# phony targets are run regardless of dependencies being up-to-date
PHONY: clean, test

