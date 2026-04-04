from sqlalchemy import create_engine, Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

# sqlite database setup
DATABASE_URL = "sqlite:///./resources.db"

# create engine
engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False}
)

# session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


# this is the resources table
class Resource(Base):
    __tablename__ = "resources"

    id = Column(Integer, primary_key=True, index=True)
    file_name = Column(String, nullable=False)
    file_path = Column(String, nullable=False)
    uploaded_at = Column(DateTime, default=datetime.utcnow)


# create table if not there
Base.metadata.create_all(bind=engine)


# db session dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# save new file to db
def save_resource(db, file_name, file_path):
    resource = Resource(file_name=file_name, file_path=file_path)
    db.add(resource)
    db.commit()
    db.refresh(resource)
    return resource


# get all files
def get_all_resources(db):
    return db.query(Resource).all()


# get one file by id
def get_resource_by_id(db, id):
    return db.query(Resource).filter(Resource.id == id).first()


# delete file from db
def delete_resource(db, id):
    resource = db.query(Resource).filter(Resource.id == id).first()
    if resource:
        db.delete(resource)
        db.commit()
        return True
    return False