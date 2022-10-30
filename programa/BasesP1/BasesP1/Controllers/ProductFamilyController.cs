using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using BasesP1.Data;
using BasesP1.Models;

namespace BasesP1.Controllers
{
    public class ProductFamilyController : Controller
    {
        private readonly SistemaCRMContext _context;

        public ProductFamilyController(SistemaCRMContext context)
        {
            _context = context;
        }

        // GET: ProductFamily
        public async Task<IActionResult> Index()
        {
              return View(await _context.FamiliaProducto.ToListAsync());
        }

        // GET: ProductFamily/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null || _context.FamiliaProducto == null)
            {
                return NotFound();
            }

            var familiaProducto = await _context.FamiliaProducto
                .FirstOrDefaultAsync(m => m.Codigo == id);
            if (familiaProducto == null)
            {
                return NotFound();
            }

            return View(familiaProducto);
        }

        // GET: ProductFamily/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: ProductFamily/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Codigo,Nombre,Activo,Descripcion")] FamiliaProducto familiaProducto)
        {
            if (ModelState.IsValid)
            {
                _context.Add(familiaProducto);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(familiaProducto);
        }

        // GET: ProductFamily/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null || _context.FamiliaProducto == null)
            {
                return NotFound();
            }

            var familiaProducto = await _context.FamiliaProducto.FindAsync(id);
            if (familiaProducto == null)
            {
                return NotFound();
            }
            return View(familiaProducto);
        }

        // POST: ProductFamily/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("Codigo,Nombre,Activo,Descripcion")] FamiliaProducto familiaProducto)
        {
            if (id != familiaProducto.Codigo)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(familiaProducto);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!FamiliaProductoExists(familiaProducto.Codigo))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(familiaProducto);
        }

        // GET: ProductFamily/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null || _context.FamiliaProducto == null)
            {
                return NotFound();
            }

            var familiaProducto = await _context.FamiliaProducto
                .FirstOrDefaultAsync(m => m.Codigo == id);
            if (familiaProducto == null)
            {
                return NotFound();
            }

            return View(familiaProducto);
        }

        // POST: ProductFamily/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            if (_context.FamiliaProducto == null)
            {
                return Problem("Entity set 'SistemaCRMContext.FamiliaProducto'  is null.");
            }
            var familiaProducto = await _context.FamiliaProducto.FindAsync(id);
            if (familiaProducto != null)
            {
                _context.FamiliaProducto.Remove(familiaProducto);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool FamiliaProductoExists(string id)
        {
          return _context.FamiliaProducto.Any(e => e.Codigo == id);
        }
    }
}
