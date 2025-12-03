program example
  use mpi
  use omp_lib
  use vernier_mod

  integer :: ierror, rank, size
  integer(kind=vik) :: handle_main, handle_parallel, handle_outer
  integer :: nthreads, thread_id
  integer :: start, finish, rate

  nthreads = 2
  call MPI_Init(ierror)

  ! Initialise
  call vernier_init(MPI_COMM_WORLD)

  ! Start
  call vernier_start( handle_main, "__global__" )

  call MPI_Comm_size(MPI_COMM_WORLD, size, ierror)
  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)

  call vernier_start( handle_outer, "outer_parallel" )
  !$omp parallel private( thread_id, handle_parallel, start, finish )

    call vernier_start( handle_parallel, "inner_parallel" )

    thread_id = omp_get_thread_num()
    print *, "Hello from rank", rank, ", thread", thread_id, "of", nthreads, "threads and", size, "ranks"


    call system_clock(start, rate)
    finish = start + rank * 1000 + thread_id * 2000
    print *, "Rank and Thread", rank, thread_id, "finish value", finish - start

    do while (.true.)
      call system_clock(start)
      if (start >= finish) exit
    end do

    call vernier_stop( handle_parallel )
 
    !$omp barrier
  !$omp end parallel
  call vernier_stop ( handle_outer )

  ! Stop
  call vernier_stop( handle_main) 

  ! Write
  call vernier_write()

  ! Finalize Vernier
  call vernier_finalize()

  call MPI_Finalize(ierror)

end program example