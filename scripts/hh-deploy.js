async function main() {
  // We get the contract to deploy
  const Greeter = await ethers.getContractFactory("TicketBookingSystem");

  const seats = [
    {
      rowNumber: 3,
      seatNumber: 4,
      showTimestamp: 500,
      seatViewURL: "wikipedia.org",
      price: 30,
    },
  ];
  const greeter = await Greeter.deploy("Batman", [seats]);

  console.log("TicketBookingSystem deployed to:", greeter.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
