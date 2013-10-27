from sqlalchemy import Column, ForeignKey, Integer, Text

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship


vv_class_reg = {}
VolunteerVeniceBase = declarative_base(class_registry=vv_class_reg)


def classReprStr(class_name, *args):
    '''
        Format the string representation of a table entry.
    '''
    return "<{} ({})>".format(class_name,
                              ", ".join(["'{}'".format(x) \
                                         for x in args]))


class VolunteerVeniceSchema(object):
    # SQLite does not support schemas.
    #__table_args__ = {'schema': 'volunteer_venice'}
    pass


class Category(VolunteerVeniceSchema, VolunteerVeniceBase):
    __tablename__ = 'category'

    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False)

    def __repr__(self):
        return classReprStr("Category",
                            self.id,
                            self.name)


class Region(VolunteerVeniceSchema, VolunteerVeniceBase):
    __tablename__ = 'region'

    id = Column(Integer, primary_key=True)
    name = Column(Text)


class Location(VolunteerVeniceSchema, VolunteerVeniceBase):
    __tablename__ = 'location'

    id = Column(Integer, primary_key=True)
    name = Column(Text)
    region_id = Column(Integer, ForeignKey(Region.id))

    region = relationship(Region, backref=__tablename__)


class Organization(VolunteerVeniceSchema, VolunteerVeniceBase):
    __tablename__ = 'orgs'

    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False)
    website = Column(Text)
    address = Column(Text)
    description = Column(Text)
    phone_number = Column(Text)
    email = Column(Text)
    picture_location = Column(Text)
    video_location = Column(Text)

    location_id = Column(Integer, ForeignKey(Location.id))
    category_id = Column(Integer, ForeignKey(Category.id))

    location = relationship(Location, backref=__tablename__)
    category = relationship(Category, backref=__tablename__)

    def __repr__(self):
        return classReprStr("Org",
                            self.id,
                            self.name,
                            self.website,
                            self.address,
                            self.description,
                            self.category,
                            self.phone_number,
                            self.email,
                            self.picture_location,
                            self.video_location)
