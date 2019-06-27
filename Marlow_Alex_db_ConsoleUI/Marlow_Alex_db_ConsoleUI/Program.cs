//Alex Marlow
//Some code in the program is from http://www.newthinktank.com/2017/04/c-tutorial-25/
//, this totorial was used to learn how to use the database interface

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Data.Common;
using System.Configuration;


namespace Marlow_Alex_db_ConsoleUI
{
    class Program
    {
        //initialises database connection variables and calls menu
        static void Main(string[] args)
        {

            Console.WriteLine("Welcome to the Custom Computer Builder DataBase UI");

            //next three lines of code were used from link on top of page
            //address of program to use the connection string on
            string provider = ConfigurationManager.AppSettings["provider"];

            //string for address of database
            string connectionString = ConfigurationManager.AppSettings["connectionString"];


            //creates the object used to create connections with the database
            DbProviderFactory factory = DbProviderFactories.GetFactory(provider);

            //loop in menu
            Menu(factory, connectionString);


        }

        //menu keeps program in a loop until exit
        static void Menu(DbProviderFactory factory, string connectionString)
        {
            bool run = true;
            while (run)
            {
                //get input
                Console.Write("Enter 1 for query, 2 for exit ");
                string val = Console.ReadLine();
                int a = Convert.ToInt32(val);
                //check choice
                if (a == 1)
                {

                    //get input
                    Console.Write("Enter 1 for insert Item, 2 for Delete Item, 3 to display Items ");
                    string inp = Console.ReadLine();
                    int b = Convert.ToInt32(inp);
                    //check choice
                    if (b == 1)
                    {
                        //add item to talbe
                        AddItem(factory, connectionString);
                    }
                    else if (b == 2)
                    {
                        //delete item from table
                        DeleteItem(factory, connectionString);
                    }
                    else if (b == 3)
                    {
                        //DisplayItem Item table
                        DisplayItem(factory, connectionString);
                    }

                }
                //end program
                else if (a == 2)
                {
                    run = false;
                }

            }

        }

        //gets an input querry
        static string GetInput()
        {
            string val;
            //get input
            val = Console.ReadLine();
            return val;
        }

        //add item to table
        static void AddItem(DbProviderFactory provider, string connectionS)
        {
            //the next 5 lines of code were changed slightly from thier source, the link at the top of the page
            using (DbConnection Myconnection =
                provider.CreateConnection())
            {

                // Giving my connection the correct connection string
                Myconnection.ConnectionString = connectionS;

                // Opening the connection
                Myconnection.Open();

                // create command for database
                DbCommand command = provider.CreateCommand();

                // set the connection for the command
                command.Connection = Myconnection;

                //get Item atributes
                Console.WriteLine("Enter ItemID");
                string ID = GetInput();
                Console.WriteLine("Enter Type");
                string Type = GetInput();
                Console.WriteLine("Enter Manufacturer");
                string man = GetInput();
                Console.WriteLine("Enter Model");
                string Model = GetInput();

                //ex:
                //1105, 'CPU', 'INTEL', 'I5-7600

                //make command
                command.CommandText = "INSERT INTO Item VALUES(" + ID + ", '" + Type + "', '" + man + "', '" + Model + "')";

                //execute
                command.ExecuteNonQuery();

                //finish
                Console.WriteLine("Item Entered");
                Myconnection.Close();
            }
        }

        //delete item from table
        static void DeleteItem(DbProviderFactory provider, string connectionS)
        {
            //the next 5 lines of code were changed slightly from their source, the link at the top of the page
            using (DbConnection Myconnection =
               provider.CreateConnection())
            {

                // Giving my connection the correct connection string
                Myconnection.ConnectionString = connectionS;

                // Opening the connection
                Myconnection.Open();

                // create command for database
                DbCommand command = provider.CreateCommand();

                // set the connection for the command
                command.Connection = Myconnection;

                //get ID
                Console.WriteLine("Enter ItemID you want to delete ");
                string ID = GetInput();

                //make command
                command.CommandText = "DELETE FROM Item WHERE Item_ID = " + ID;
                //execute
                command.ExecuteNonQuery();

                //finish
                Console.WriteLine("Item Deleted");

                Myconnection.Close();
            }
        }

        //display the table of Items
        static void DisplayItem(DbProviderFactory provider, string connectionS)
        {   //the next 5 lines of code were changed slightly from their source, the link at the top of the page
            using (DbConnection Myconnection =
                provider.CreateConnection())
            {

                // Giving my connection the correct connection string
                Myconnection.ConnectionString = connectionS;

                // Opening the connection
                Myconnection.Open();

                // create command for database
                DbCommand command = provider.CreateCommand();

                // set the connection for the command
                command.Connection = Myconnection;

                //querry
                command.CommandText = "Select * From Item";

                using (DbDataReader dataReader = command.ExecuteReader())
                {
                    // Advance to the next results
                    while (dataReader.Read())
                    {
                        //loops through datareader and prints each element
                        for (int X = 0; X < dataReader.VisibleFieldCount; X++)
                        {
                            Console.Write($"{dataReader[X]} ".PadRight(15));
                        }

                        Console.WriteLine();
                    }
                }
                //close connection
                Myconnection.Close();
            }
        }
    }
}