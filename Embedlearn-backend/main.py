# EMBEDDEDLEARN backend 
# PDF upload, view, download, delete

from fastapi import FastAPI, UploadFile, File, HTTPException, Depends
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
import os, uuid, aiofiles

from database import save_resource, get_all_resources, get_resource_by_id, delete_resource, get_db

app = FastAPI()

# creayte upload folder if not exist
UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), "uploads")
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


# ---------------- UPLOAD ----------------
@app.post("/upload")
async def upload_pdf(file: UploadFile = File(...), db: Session = Depends(get_db)):
    try:
        
        filename = str(uuid.uuid4()) + "_" + file.filename
        path = os.path.join(UPLOAD_FOLDER, filename)

        # file save
        async with aiofiles.open(path, "wb") as f:
            data = await file.read()
            await f.write(data)

        # save in db
        res = save_resource(db, file.filename, path)

        return {"msg": "file uploaded successfuly", "data": res}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ---------------- VIEW ----------------
@app.get("/view/{id}")
async def view_pdf(id: int, db: Session = Depends(get_db)):
    try:
        res = get_resource_by_id(db, id)

        if not res:
            raise HTTPException(status_code=404, detail="not found")

        return FileResponse(res.file_path, media_type="application/pdf")

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ---------------- DOWNLOAD ----------------
@app.get("/download/{id}")
async def download_pdf(id: int, db: Session = Depends(get_db)):
    try:
        res = get_resource_by_id(db, id)

        if not res:
            raise HTTPException(status_code=404, detail="not found")

        return FileResponse(
            res.file_path,
            media_type="application/pdf",
            filename=res.file_name
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ---------------- DELETE ----------------
@app.delete("/resource/{id}")
async def delete_pdf(id: int, db: Session = Depends(get_db)):
    try:
        res = get_resource_by_id(db, id)

        if not res:
            raise HTTPException(status_code=404, detail="not found")

        # file delete
        os.remove(res.file_path)

        # remove from db 
        delete_resource(db, id)

        return {"msg": "deleted"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ---------------- GET ALL ----------------
@app.get("/resources")
async def get_all(db: Session = Depends(get_db)):
    return {"data": get_all_resources(db)}