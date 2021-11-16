async function main() {
  // We get the contract to deploy
  const ticketBookingSystemFactory = await ethers.getContractFactory(
    "TicketBookingSystem"
  );

  const seats = [
    {
      rowNumber: 3,
      seatNumber: 4,
      timestamp: 500,
      seatViewURL: "wikipedia.org",
      price: 30,
    },
  ];
  const ticketBookingSystem = await ticketBookingSystemFactory.deploy(
    "Batman",
    2 * 3600,
    seats
  );

  console.log("TicketBookingSystem deployed to:", ticketBookingSystem.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
