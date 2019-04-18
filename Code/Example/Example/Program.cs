using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Example
{
    class Program
    {

        static Invoice _invoices = new Invoice();
        static List<Play> plays = new List<Play>()
            {
                new Play() { Name= "Hamlet",type= "tragedy" },
                new Play() { Name= "As You Like It",type= "comedy" },
                new Play() { Name= "Othello",type= "tragedy" }
            };
        static void Main(string[] args)
        {
            _invoices.InitSource();
            var str= Statement(_invoices,plays);
            Console.WriteLine(str);
            Console.ReadLine();

        }
        public static string  Statement(Invoice invoice, List<Play> plays)
        {
            var totalAmount = 0;
            var volumeCredits = 0;
            var result = invoice.Customer;

            foreach (var perf in invoice.performances)
            {
                var thisAmount = amountFor(perf);
                volumeCredits += volumeCreditsFor(volumeCredits, perf);

                result += playFor(perf)?.Name + (thisAmount/100) + (perf.audience) + "\r\n"; ;
                totalAmount += thisAmount;
                
            }
            result += totalAmount / 100 +"\r\n";
            result += volumeCredits + "\r\n"; ;
            return result;
        }

        private static int volumeCreditsFor(int volumeCredits, Performance perf)
        {
            volumeCredits += Math.Max(perf.audience - 30, 0);
            if ("comedy" == playFor(perf)?.type) volumeCredits += perf.audience/5;
            return volumeCredits;
        }

        private static Play playFor(Performance perf)
        {
            var play = plays.FirstOrDefault(item => item.Name.ToLower().Equals(perf.playID.ToLower()));
            return play;
        }

        private static int amountFor( Performance perf)
        {
            var thisAmount = 0;
            var play = playFor(perf);
            if (play == null)
            {
               return 0;
            }
            switch (play.type)
            {
                case "tragedy":
                    thisAmount = 40000;
                    if (perf.audience > 30)
                    {
                        thisAmount += 1000*(perf.audience - 30);
                    }
                    break;
                case "comedy":
                    thisAmount = 30000;
                    if (perf.audience > 20)
                    {
                        thisAmount += 10000 + 500*(perf.audience - 20);
                    }
                    thisAmount += 300*perf.audience;
                    break;
                default:
                    throw new Exception(play.type);
                    break;
            }
            return thisAmount;
        }
    }


    

    public class Play
    {
        public string Name { get;   set; }
        public string type { get;   set; }
       
    }

    public class Invoice
    {
        public string Customer { get;private set; }
        public List<Performance> performances { get; private set; }
    
        public void InitSource()
        {
            if (performances ==null)
            {
                performances = new List<Performance>();
            }
            performances.Add(new Performance() { playID = "hamlet", audience  = 55});
            performances.Add(new Performance() { playID = "as­like", audience  = 35 });
            performances.Add(new Performance() { playID = "othello", audience = 40 });
        }
    }

    public class Performance
    {
        public string playID   { get;  set; }
        public int audience { get;  set; }
    }
}
