using System.Security.Policy;

namespace BasesP1.Models
{
    public class ClientDataContainer
    {
        public List<Zone> zones { get; set; }
        public List<Sector> sectors { get; set; }
        public List<User> user_logins { get; set; }
    }
}
